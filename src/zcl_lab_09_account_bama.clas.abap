CLASS zcl_lab_09_account_bama DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      set_iban IMPORTING iban TYPE string,
      get_iban RETURNING VALUE(iban) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA iban TYPE string.

ENDCLASS.



CLASS zcl_lab_09_account_bama IMPLEMENTATION.

  METHOD set_iban.
    me->iban = iban.
  ENDMETHOD.

  METHOD get_iban.
    iban = me->iban.
  ENDMETHOD.

ENDCLASS.
