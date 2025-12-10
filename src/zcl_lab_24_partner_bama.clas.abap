CLASS zcl_lab_24_partner_bama DEFINITION
  PUBLIC
*  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_company_capital RETURNING VALUE(rv_value) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_24_PARTNER_BAMA IMPLEMENTATION.


  METHOD get_company_capital.

    DATA(lo_instance) = NEW zcl_lab_23_company_bama(  ).
    lo_instance->capital = 'New York'.
    rv_value = lo_instance->capital.

  ENDMETHOD.
ENDCLASS.
