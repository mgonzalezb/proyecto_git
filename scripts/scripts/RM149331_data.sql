DECLARE
   CURSOR cur_ret IS
      SELECT * FROM slu.tasiecab
      WHERE aa_ejercicio_frm = 2025
      AND c_formulario = 'FRP'
      AND n_formulario IN (16493);
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
         AND a.t_factura IN ('FRP')
         --and a.e_factura not in 'X'
         AND a.o_factura IN 
      (16493);
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


