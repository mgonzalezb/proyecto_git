UPDATE slu.bconjunto_gc
SET x_query_rec = 
'SELECT ac.o_conjunto O_CONJUNTO,
    dm.o_matriz O_MATRIZ,
    dm.o_dmatriz O_DMATRIZ,
    1 O_CORTE_FRM,
    a.aa_factura AA_EJERCICIO_FRM,
    a.t_factura T_FORMULARIO,
    a.o_factura O_FORMULARIO,
    a.aa_factura AA_EJERCICIO,
    NULL O_ASIENTO,
    NULL O_ITEM,
    DECODE(b.t_factura_orig,''FRA'',TO_CHAR(slu.spap_funcion_gc.obtener_retorno(dm.f_cuenta_contable,b.aa_factura_orig,b.t_factura_orig,b.o_factura_orig,a.aa_factura,a.c_numcred))
                                 ,TO_CHAR(slu.spap_funcion_gc.obtener_retorno(dm.f_cuenta_contable,a.aa_factura,a.t_factura,a.o_factura,a.aa_factura,a.c_numcred))) C_CUENTA,
    dm.t_imputacion T_IMPUTACION,
    ''A'' T_GENERACION,
    DECODE(dm.t_operacion,''H'',''D'',''D'',''H'') T_OPERACION,
    DECODE(dm.c_axt, ''FFC1'', ROUND(a.i_imputado * TO_NUMBER(0||''.''||TO_NUMBER(100 - slu.spap_parametro.valor(''P_CONTA_FFC'')),''9.99''), 2),
                     ''FFC2'', ROUND(a.i_imputado * TO_NUMBER(0||''.''||TO_NUMBER(100 - slu.spap_parametro.valor(''P_CONTA_FFC'')),''9.99''), 2),
                     ''FFC3'', ROUND(a.i_imputado * TO_NUMBER(0||''.''||slu.spap_parametro.valor(''P_CONTA_FFC''),''9.99''), 2),
                     ''FFC4'', ROUND(a.i_imputado * TO_NUMBER(0||''.''||slu.spap_parametro.valor(''P_CONTA_FFC''),''9.99''), 2),
                     ''-'', a.i_imputado
           ) I_IMPUTADO,
    DECODE(b.t_factura_orig,''FRA'',TO_NUMBER(slu.spap_funcion_gc.obtener_retorno (dm.f_relacion,b.aa_factura_orig,b.t_factura_orig,b.o_factura_orig,a.aa_factura,a.c_numcred)),
                                  TO_NUMBER(slu.spap_funcion_gc.obtener_retorno (dm.f_relacion,a.aa_factura,a.t_factura,a.o_factura,a.aa_factura,a.c_numcred))) O_RELACION,
    1 C_RELITEM,
    440 C_SERVICIO,
    ''AC'' C_SERVICIO_CONTABLE,
    CASE WHEN EXTRACT (YEAR FROM SYSDATE) = a.aa_factura THEN
            TO_DATE(SYSDATE,''DD/MM/RRRR'')
         WHEN EXTRACT (YEAR FROM SYSDATE) <> a.aa_factura THEN
            TO_DATE(''31/12/''||a.aa_factura,''DD/MM/RRRR'')
    END F_ASIENTO,
    a.xl_observaciones XL_ASIENTO,
    NULL O_ASIENTO_OUT,
    NULL C_SERVICIO_CONT_OUT,
    NULL C_CENTRO_COSTO,
    NULL C_DESCRIPCION,
    slu.obtener_usuario C_USUARIO_ALTA,
    slu.spap_fecha.fecha_bd FH_ALTA
FROM (SELECT f.aa_factura aa_factura,
            f.t_factura t_factura,
            f.o_factura o_factura,
            g.aa_factura aa_factura_orig,
            g.t_factura t_factura_orig,
            g.o_factura o_factura_orig
       FROM slu.tfactura_gs f,
            slu.tfactura_gs g
      WHERE f.aa_factura_orig = g.aa_factura
        AND f.o_factura_orig = g.o_factura
        ) b,
    (SELECT t.aa_factura,
            t.t_factura,
            t.o_factura,
            t.f_recepcion,
            t.xl_observaciones,
            d.o_ffi,
            d.c_numcred,
            SUM(d.i_devengado) i_imputado,
            t.f_autorizacion
       FROM slu.tfactura_gs t,
            slu.dfacgs_ffi d
      WHERE t.aa_factura = d.aa_factura
        AND t.o_factura = d.o_factura
      GROUP BY t.aa_factura,t.t_factura,t.o_factura,
               t.f_recepcion,t.xl_observaciones,
               d.o_ffi,d.c_numcred,
               t.f_autorizacion) a,
    slu.aconjunto_matriz_gc ac,
    slu.tmatriz_gc tm,
    slu.dmatriz_gc dm
WHERE 1=1
AND ac.o_matriz = tm.o_matriz
AND tm.o_matriz = dm.o_matriz
AND dm.aa_ejercicio = b.aa_factura_orig
AND dm.c_formulario = b.t_factura_orig
AND ac.o_conjunto = slu.spat_contabilidad_aut.obtener_conjunto_frm_gc (b.aa_factura_orig, b.t_factura_orig, b.o_factura_orig)
AND b.aa_factura = a.aa_factura
AND b.t_factura = a.t_factura
AND b.o_factura = a.o_factura
AND a.i_imputado <> 0
AND a.aa_factura = :1
AND a.t_factura = :2
AND a.o_factura = :3
AND slu.spat_contabilidad_aut.obtener_conjunto_frm_gc (a.aa_factura,a.t_factura,a.o_factura) = :4
ORDER BY o_dmatriz desc, a.o_ffi'
WHERE o_conjunto = 232
/
DECLARE
   CURSOR cur_ret IS
      SELECT * FROM slu.tasiecab
      WHERE aa_ejercicio_frm = 2025
      AND c_formulario = 'NC'
      AND n_formulario IN  
      (2666,  5516, 8583, 11662, 12522, 19138, 29300, 29529, 29532, 32840, 40385, 48364, 48653, 48657, 48812, 57187, 59265, 59266, 59325, 59327, 59429, 59432, 59853, 62648);
   --
   l_rutina    ing_tregistro_error.x_rutina%TYPE := 'SLU.SPAT_CIERRE_CONTABLE.borrar_cierre';
BEGIN
   --
   FOR i IN cur_ret LOOP
      DELETE CG_TASIEHIS
       WHERE aa_ejercicio        = i.aa_ejercicio
         AND o_asiento           = i.o_asiento
         AND c_servicio_contable = i.c_servicio_contable;
      --
      DELETE CG_RASIENTO
       WHERE aa_ejercicio        = i.aa_ejercicio
         AND o_asiento           = i.o_asiento
         AND c_servicio_contable = i.c_servicio_contable;
      --
      DELETE CG_DASIEIT
       WHERE aa_ejercicio        = i.aa_ejercicio
         AND o_asiento           = i.o_asiento
         AND c_servicio_contable = i.c_servicio_contable;
      --
      DELETE CG_RDASIEIT
       WHERE aa_ejercicio        = i.aa_ejercicio
         AND o_asiento           = i.o_asiento
         AND c_servicio_contable = i.c_servicio_contable;
      --
      DELETE CG_TASIECAB
       WHERE aa_ejercicio        = i.aa_ejercicio
         AND o_asiento           = i.o_asiento
         AND c_servicio_contable = i.c_servicio_contable;
      --
      DELETE CG_RASIENTO
       WHERE aa_ejercicio        = i.aa_ejercicio
         AND o_asiento           = i.o_asiento
         AND c_servicio_contable = i.c_servicio_contable;
   END LOOP;
   --
   --SLU.SPAT_CIERRE_CONTABLE.regen_acumuladores (p_aa_ejercicio);
EXCEPTION
   WHEN Ing_SPAR_Manejo_Error.Error_No_Esperado OR Ing_SPAR_Manejo_Error.Error_Esperado THEN
      Ing_SPAR_Manejo_Error.Subscribir ('RUTINA: '||l_rutina);
      ROLLBACK WORK;
      RAISE;
   WHEN OTHERS THEN
      Ing_SPAR_Manejo_Error.Levantar('ENM',SQLERRM,'RUTINA: '||l_rutina);
      ROLLBACK WORK;
      RAISE Ing_SPAR_Manejo_Error.Error_No_Esperado;
END;
/
DECLARE
   CURSOR cur_ret IS
      SELECT *
        FROM (SELECT o.aa_factura aa_comprobante,
                     o.t_factura t_comprobante,
                     o.o_factura n_comprobante,
                     o.*,
                     o.t_factura c_formulario
                FROM slu.tfactura_gs o) a
       WHERE a.aa_factura = 2025
         AND a.t_factura IN ('NC')
         --and a.e_factura not in 'X'
         AND a.o_factura IN 
      (2666,  5516, 8583, 11662, 12522, 19138, 29300, 29529, 29532, 32840, 40385, 48364, 48653, 48657, 48812, 57187, 59265, 59266, 59325, 59327, 59429, 59432, 59853, 62648);
   --
BEGIN
   --
   FOR i IN cur_ret LOOP
      IF
      cg_spa_asientos_contables.SFN_Generacion_Automatica (i.aa_comprobante,  --aa_formulario
                                                           i.t_comprobante, --t_formulario
                                                           i.n_comprobante,  --o_formulario
                                                           NULL,   --p_servicio
                                                           'A'    --p_estado
                                                           ) != 'SI' THEN
         dbms_output.put_line('Error!');
      ELSE
         dbms_output.put_line('GENERADO');
      END IF;
   END LOOP;
   --
EXCEPTION
    --
    WHEN ING_SPAR_MANEJO_ERROR.Error_No_Esperado OR ING_SPAR_MANEJO_ERROR.Error_Esperado THEN
        dbms_output.put_line('*** ERROR ***');
        dbms_output.put_line(ING_SPAR_MANEJO_ERROR.get_x_debug);
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 1, 250));
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 250, 250));
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 500, 250));
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 750, 250));
        ROLLBACK WORK;
        --
   WHEN OTHERS THEN
        --
        dbms_output.put_line('*** ERROR ***');
        dbms_output.put_line(SQLCODE || ' - ' || SQLERRM);
        ROLLBACK WORK;
        --
END;
/
