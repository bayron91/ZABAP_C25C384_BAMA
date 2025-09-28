CLASS zcl_lab_01_ejec_bama DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_01_ejec_bama IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "Class zcl_lab_04_person_bama
    DATA(lo_person) = NEW zcl_lab_04_person_bama( ).

    lo_person->set_age( 33 ).
    lo_person->get_age( IMPORTING ev_age = DATA(lv_age) ).
    out->write( |Age person: { lv_age }| ).

    "Class zcl_lab_05_flight_bama
    DATA(lo_flight) = NEW zcl_lab_05_flight_bama( ).

    out->write( |\n| ).
    IF lo_flight->get_flight_exists( iv_carrier_id    = 'UA'
                                     iv_connection_id = '0058' ) EQ abap_true.
      out->write( |The flight exist| ).
    ELSE.
      out->write( |The flight doesn't exist| ).
    ENDIF.

    "Class zcl_lab_06_elements_bama
    DATA(lo_elements) = NEW zcl_lab_06_elements_bama( ).
    DATA ls_elements TYPE zcl_lab_06_elements_bama=>ty_elem_objects.

    ls_elements = VALUE #( class = 'zcl_lab_06_elements_bama'
                           instance = 'lo_elements'
                           reference = 'ms_object' ).

    lo_elements->set_object( ls_elements ).
    out->write( |\n| ).
    out->write( lo_elements->ms_object ).

    out->write( |\n| ).
    out->write( |Constants 1: { zcl_lab_06_elements_bama=>ty_languages-language1 }| ).
    out->write( |Constants 2: { zcl_lab_06_elements_bama=>ty_languages-language2 }| ).
    out->write( |Constants 3: { zcl_lab_06_elements_bama=>ty_languages-language3 }| ).
    out->write( |Constants 4: { zcl_lab_06_elements_bama=>ty_languages-language4 }| ).

    "Class zcl_lab_07_student_bama
    DATA(lo_student) = NEW zcl_lab_07_student_bama( ).
    lo_student->set_birth_date( cl_abap_context_info=>get_system_date( ) ).

    "Class zcl_lab_08_work_record_bama
    zcl_lab_08_work_record_bama=>open_new_record( iv_date = cl_abap_context_info=>get_system_date( )
                                                  iv_first_name = 'Bayron'
                                                  iv_last_name = 'Martinez Alvaran' ).

    "Class zcl_lab_09_account_bama
    DATA(lo_account) = NEW zcl_lab_09_account_bama( ).
    lo_account->set_iban( 'DE89 3704 0044 0532 0130 00' ).
    out->write( |\n| ).
    out->write( |IBAN: { lo_account->get_iban( ) }| ).

  ENDMETHOD.

ENDCLASS.
