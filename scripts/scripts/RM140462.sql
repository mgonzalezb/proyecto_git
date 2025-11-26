DECLARE
    l_c_menuitem slu.tmenuitem.c_menu%TYPE;
BEGIN
    --Crear un Item del Menu
    INSERT INTO slu.tmenuitem (c_menu, c_menuitem, xc_menuitem, xl_menuitem, c_tipoaccion, c_accion, m_es_hoja, n_orden, c_rol_aplicacion, v_nombre_manual)
         VALUES ( 105371                      --Numero de item padre
                , DBMS_UTILITY.GET_HASH_VALUE ('M_REPORTE_DAS', 10000, 990000)
                ,'Reporte Regularización DAS'    --Nombre Corto
                ,'Reporte Regularización DAS' --Nombre Largo
                ,'F'                        --NO CAMBIA (Tipo de menu)
                ,'gs_reporte_das'        --Nombre Forms
                ,'S'                        --NO CAMBIA (Es hoja)
                , 70                         --Numero de orden en la agrupacion
                ,'ROL_EJECUCION'
                ,NULL              --NO CAMBIA
               )
        RETURNING c_menuitem INTO l_c_menuitem;

    ---

    --Asigno Permiso al Forms.
    INSERT INTO slu.dmenu_permiso (c_menuitem, c_menu_permiso, m_alta, m_baja, m_modif,m_consulta, m_consrestring, m_consbaja, m_listado)
         VALUES (DBMS_UTILITY.GET_HASH_VALUE ('M_REPORTE_DAS', 10000, 990000)
                , 2   --NO CAMBIA
                ,'N'  --Menu del Forms Alta
                ,'N'  --Menu del Forms Baja
                ,'N'  --Menu del Forms Modif
                ,'S'  --Menu del Forms Consulta
                ,'N'  --Menu del Forms Consrestring
                ,'N'  --Menu del Forms Consbaja
                ,'N'); --Menu del Forms Listado

    --Roles.
    INSERT INTO slu.amenuitem_rolusu (c_menuitem, c_menu_permiso, c_rol_usuario)
         VALUES (DBMS_UTILITY.GET_HASH_VALUE ('M_REPORTE_DAS', 10000, 990000)
                , 2
                ,'ROL_GENERAL');

    COMMIT;
END;
/