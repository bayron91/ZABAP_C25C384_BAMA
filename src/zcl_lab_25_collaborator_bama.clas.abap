CLASS zcl_lab_25_collaborator_bama DEFINITION INHERITING FROM zcl_lab_24_partner_bama
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_capital RETURNING VALUE(rv_value) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_25_COLLABORATOR_BAMA IMPLEMENTATION.


  METHOD get_capital.

    DATA(lo_instance) = NEW zcl_lab_23_company_bama(  ).
    lo_instance->capital = 'Paris'.
    rv_value = lo_instance->capital.

  ENDMETHOD.
ENDCLASS.
