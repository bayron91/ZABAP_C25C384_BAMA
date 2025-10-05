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

    "4. Narrowing Cast


*    "3.Redefinición de métodos
*    DATA(lo_flight_price) = NEW zcl_lab_15_flight_price_bama(  ).
*
*    SELECT SINGLE FROM /dmo/flight
*        FIELDS *
*        WHERE carrier_id = 'UA'
*        INTO @DATA(ls_flight).
*
*    lo_flight_price->add_price( ls_flight ).
*    out->write( name = 'Flight price' data = lo_flight_price->mt_flights ).
*
*    DATA(lo_price_discount) = NEW zcl_lab_16_price_discount_bama(  ).
*    lo_price_discount->add_price( ls_flight ).
*    out->write( |\n| ).
*    out->write( name = 'Price discount' data = lo_price_discount->mt_flights ).
*
*    DATA(lo_super_discount) = NEW zcl_lab_17_super_discount_bama(  ).
*    lo_super_discount->add_price( ls_flight ).
*    out->write( |\n| ).
*    out->write( name = 'Super discount' data = lo_super_discount->mt_flights ).

*    "2.Constructores con herencia
*    DATA(lo_grid) = NEW zcl_lab_14_grid_bama( 'Grid box' ).
*    out->write( |View type: { lo_grid->get_view_type(  ) }| ).
*    out->write( |Box: { lo_grid->get_box(  ) }| ).

*    "1.Herencia
*    DATA(lo_linux_system) = NEW zcl_lab_12_linux_bama(  ).
*    out->write( |Architecture: { lo_linux_system->get_architecture( ) }| ).


*    "Class zcl_lab_04_person_bama
*    DATA(lo_person) = NEW zcl_lab_04_person_bama( ).
*
*    lo_person->set_age( 33 ).
*    lo_person->get_age( IMPORTING ev_age = DATA(lv_age) ).
*    out->write( |Age person: { lv_age }| ).
*
*    "Class zcl_lab_05_flight_bama
*    DATA(lo_flight) = NEW zcl_lab_05_flight_bama( ).
*
*    out->write( |\n| ).
*    IF lo_flight->get_flight_exists( iv_carrier_id    = 'UA'
*                                     iv_connection_id = '0058' ) EQ abap_true.
*      out->write( |The flight exist| ).
*    ELSE.
*      out->write( |The flight doesn't exist| ).
*    ENDIF.
*
*    "Class zcl_lab_06_elements_bama
*    DATA(lo_elements) = NEW zcl_lab_06_elements_bama( ).
*    DATA ls_elements TYPE zcl_lab_06_elements_bama=>ty_elem_objects.
*
*    ls_elements = VALUE #( class = 'zcl_lab_06_elements_bama'
*                           instance = 'lo_elements'
*                           reference = 'ms_object' ).
*
*    lo_elements->set_object( ls_elements ).
*    out->write( |\n| ).
*    out->write( lo_elements->ms_object ).
*
*    out->write( |\n| ).
*    out->write( |Constants 1: { zcl_lab_06_elements_bama=>ty_languages-language1 }| ).
*    out->write( |Constants 2: { zcl_lab_06_elements_bama=>ty_languages-language2 }| ).
*    out->write( |Constants 3: { zcl_lab_06_elements_bama=>ty_languages-language3 }| ).
*    out->write( |Constants 4: { zcl_lab_06_elements_bama=>ty_languages-language4 }| ).
*
*    "Class zcl_lab_07_student_bama
*    DATA(lo_student) = NEW zcl_lab_07_student_bama( ).
*    lo_student->set_birth_date( cl_abap_context_info=>get_system_date( ) ).
*
*    "Class zcl_lab_08_work_record_bama
*    zcl_lab_08_work_record_bama=>open_new_record( iv_date = cl_abap_context_info=>get_system_date( )
*                                                  iv_first_name = 'Bayron'
*                                                  iv_last_name = 'Martinez Alvaran' ).
*
*    "Class zcl_lab_09_account_bama
*    DATA(lo_account) = NEW zcl_lab_09_account_bama( ).
*    lo_account->set_iban( 'DE89 3704 0044 0532 0130 00' ).
*    out->write( |\n| ).
*    out->write( |IBAN: { lo_account->get_iban( ) }| ).
*
*    "Class zcl_lab_10_constructor_bama
*    DATA(lo_constructor) = NEW zcl_lab_10_constructor_bama(  ).
*    out->write( lo_constructor->log ).

  ENDMETHOD.

ENDCLASS.
