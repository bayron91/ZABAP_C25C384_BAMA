CLASS zcl_lab_11_system_bama DEFINITION
  PUBLIC
*  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA architecture TYPE string VALUE '64BITS'.

    METHODS get_architecture RETURNING VALUE(rv_architecture) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_11_system_bama IMPLEMENTATION.

  METHOD get_architecture.
    rv_architecture = me->architecture.
  ENDMETHOD.

ENDCLASS.
