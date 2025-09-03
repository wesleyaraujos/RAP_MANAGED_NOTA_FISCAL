CLASS LHC_ZR_WAS_NF_HEADER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrWasNfHeader
        RESULT result,
      validateCoreData FOR VALIDATE ON SAVE
            IMPORTING keys FOR ZrWasNfHeader~validateCoreData,
      fillFixedValue FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrWasNfHeader~fillFixedValue,
      changeFixedValue FOR MODIFY
            IMPORTING keys FOR ACTION ZrWasNfHeader~changeFixedValue.

          METHODS changePartner FOR MODIFY
            IMPORTING keys FOR ACTION ZrWasNfHeader~changePartner.
ENDCLASS.

CLASS LHC_ZR_WAS_NF_HEADER IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD validateCoreData.

    READ ENTITIES OF ZR_WAS_NF_HEADER IN LOCAL MODE
      ENTITY ZrWasNfHeader
      FIELDS ( Docnum Parid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partner)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    LOOP AT lt_partner INTO DATA(ls_partner).

        IF ls_partner-Parid(1) NE '9'.

            INSERT VALUE #( docnum = ls_partner-Docnum ) INTO TABLE failed-zrwasnfheader.

            INSERT VALUE #(
               Docnum = ls_partner-Docnum
               %msg = new_message_with_text( text = 'Partner must start with 9' )
               %element-Parid = if_abap_behv=>mk-on
            ) INTO TABLE reported-zrwasnfheader.

        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD fillFixedValue.

    READ ENTITIES OF ZR_WAS_NF_HEADER IN LOCAL MODE
      ENTITY ZrWasNfHeader
      FIELDS ( Docnum Fixed_value )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_nota_fiscal).

    LOOP AT lt_nota_fiscal INTO DATA(ls_nf) WHERE Fixed_value IS INITIAL.
      MODIFY ENTITIES OF ZR_WAS_NF_HEADER IN LOCAL MODE
        ENTITY ZrWasNfHeader
        UPDATE FIELDS ( Fixed_value )
        WITH VALUE #( ( %tky = ls_nf-%tky
                       Fixed_value = 'Valor Fixo'
                       %control-Fixed_value = if_abap_behv=>mk-on ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD changeFixedValue.

    SELECT FROM zwas_nf_header
        FIELDS Docnum, Parid, fixed_value
        INTO TABLE @data(lt_Header) .

    LOOP AT lt_Header INTO DATA(ls_nf).

        MODIFY ENTITIES OF ZR_WAS_NF_HEADER IN LOCAL MODE
              ENTITY ZrWasNfHeader
            UPDATE FIELDS ( Fixed_value )
              WITH VALUE #( ( Docnum = ls_nf-Docnum
                              Fixed_value = |{ ls_nf-fixed_value }-X|
                              ) ).


    ENDLOOP.

      INSERT VALUE #(
        %msg = new_message_with_text( text = |{ lines( lt_Header ) } records changed|
        severity = if_abap_behv_message=>severity-success )
      ) INTO TABLE reported-zrwasnfheader.

  ENDMETHOD.

  METHOD changePartner.

    SELECT FROM zwas_nf_header
        FIELDS Docnum, Parid, fixed_value
        INTO TABLE @data(lt_Header) .

    LOOP AT lt_Header INTO DATA(ls_nf).

        MODIFY ENTITIES OF ZR_WAS_NF_HEADER IN LOCAL MODE
              ENTITY ZrWasNfHeader
            UPDATE FIELDS ( Parid )
              WITH VALUE #( ( Docnum = ls_nf-Docnum
                              Parid = |{ ls_nf-Parid }-P|
                              ) ).


    ENDLOOP.

      INSERT VALUE #(
        %msg = new_message_with_text( text = |{ lines( lt_Header ) } records changed|
        severity = if_abap_behv_message=>severity-success )
      ) INTO TABLE reported-zrwasnfheader.

  ENDMETHOD.

ENDCLASS.
