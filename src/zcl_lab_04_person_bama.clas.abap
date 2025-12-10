CLASS zcl_lab_04_person_bama DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      set_age IMPORTING iv_age TYPE i,
      get_age EXPORTING ev_age TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: age TYPE i.

ENDCLASS.



CLASS ZCL_LAB_04_PERSON_BAMA IMPLEMENTATION.


  METHOD get_age.
    ev_age = me->age.
  ENDMETHOD.


  METHOD set_age.
    age = iv_age.
  ENDMETHOD.
ENDCLASS.
