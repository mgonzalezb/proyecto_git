UPDATE slu.bconjunto_gc
SET x_query_rec = 
'SELECT ac.o_conjunto O_CONJUNTO,
       dm.o_matriz O_MATRIZ,
       dm.o_dmatriz O_DMATRIZ,
       1 O_CORTE_FRM,
       b.aa_comprobante AA_EJERCICIO_FRM,
       b.t_comprobante T_FORMULARIO,
       b.o_comprobante O_FORMULARIO,
       DECODE (pre_spap_ejercicio.Fcontable_esta_abierto(a.aa_comprobante,ing_spar_fecha.fecha_bd),''SI'', a.aa_comprobante,
               slu.spap_ejercicio.S_Vigente_Contable) AA_EJERCICIO,
       NULL O_ASIENTO,
       NULL O_ITEM,
       c.C_CUENTA C_CUENTA,
       dm.t_imputacion T_IMPUTACION,
       ''A'' T_GENERACION,
       DECODE(dm.t_operacion,''H'',''D'',''D'',''H'') T_OPERACION,
       c.i_imputado I_IMPUTADO,
       c.O_RELACION O_RELACION,
       1 C_RELITEM,
       440 C_SERVICIO,
       ''AC'' C_SERVICIO_CONTABLE,
       DECODE (EXTRACT (YEAR FROM a.f_autorizacion), ''2022'', TO_DATE(''01/01/2023'',''DD/MM/RRRR'')
                                                   ,a.f_autorizacion) F_ASIENTO,
       ''OP DE DEVOLUCION DE RETENCIONES'' XL_ASIENTO,
       NULL O_ASIENTO_OUT,
       NULL C_SERVICIO_CONT_OUT,
       NULL C_CENTRO_COSTO,
       NULL C_DESCRIPCION,
       slu.obtener_usuario C_USUARIO_ALTA,
       slu.spap_fecha.fecha_bd FH_ALTA
  FROM (SELECT aa_formulario aa_comprobante,
               t_formulario t_comprobante,
               o_formulario o_comprobante,
               f_autorizacion
          FROM slu.tformulario) a,
       (SELECT aa_opliq aa_comprobante,
               t_opliq t_comprobante,
               o_opliq o_comprobante,
               aa_pago,
               o_pago,
               i_liquidado i_imputado
               --(SELECT ia_devengado FROM slu.tformulario WHERE aa_formulario = aa_opliq AND t_formulario = t_opliq AND o_formulario = o_opliq) i_imputado
          FROM slu.tconstancia_ret) b,
       (SELECT ta.aa_ejercicio_frm aa_comprobante,
               ta.c_formulario t_comprobante,
               ta.n_formulario o_comprobante,
               da.o_item,
               da.c_cuenta,
               da.t_operacion,
               da.i_imputado,
               da.o_relacion
          FROM slu.tasiecab ta,
               slu.dasieit da
         WHERE 1=1
           AND ta.aa_ejercicio = da.aa_ejercicio
           AND ta.o_asiento = da.o_asiento
           AND ta.c_servicio_contable = da.c_servicio_contable) c,
       slu.aconjunto_matriz_gc ac,
       slu.tmatriz_gc tm,
       slu.dmatriz_gc dm
 WHERE 1=1
   AND ac.o_matriz = tm.o_matriz
   AND tm.o_matriz = dm.o_matriz
   AND dm.aa_ejercicio = b.aa_comprobante
   AND dm.tipo_formulario = b.t_comprobante
   AND dm.t_operacion = c.t_operacion
   AND a.aa_comprobante = b.aa_comprobante
   AND a.t_comprobante = b.t_comprobante
   AND a.o_comprobante = b.o_comprobante
   AND c.aa_comprobante = b.aa_pago
   AND c.t_comprobante = ''RET''
   AND c.o_comprobante = b.o_pago
   AND b.aa_comprobante = :1
   AND b.t_comprobante = :2
   AND b.o_comprobante = :3
   AND ac.o_conjunto = :4
 ORDER BY o_matriz, c.o_item'
WHERE o_conjunto = 247
/
DECLARE
   CURSOR cur_ret IS
      SELECT * FROM slu.tasiecab
      WHERE aa_ejercicio_frm = 2025
      AND c_formulario = 'C42'
      AND n_formulario IN (6201);
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
      SELECT aa_formulario aa_comprobante, t_formulario t_comprobante, o_formulario n_comprobante FROM slu.tformulario
      where aa_formulario = 2025
      and o_formulario = 6201
      and t_formulario = 'C42';
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
DECLARE
   CURSOR cur_ret IS
      SELECT * FROM slu.tasiecab
      WHERE aa_ejercicio_frm = 2025
      AND c_formulario = 'PAG'
      AND n_formulario = 17704;
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
      SELECT aa_pago aa_comprobante, 'PAG' t_comprobante, o_pago n_comprobante FROM slu.tpago
      WHERE aa_pago = 2025
      AND o_pago = 17704;
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