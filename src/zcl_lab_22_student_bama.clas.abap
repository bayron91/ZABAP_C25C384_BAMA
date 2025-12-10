CLASS zcl_lab_22_student_bama DEFINITION INHERITING FROM zcl_lab_21_classroom_bama
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS assign_student RETURNING VALUE(ro_object) TYPE REF TO zcl_lab_21_classroom_bama.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_22_STUDENT_BAMA IMPLEMENTATION.


  METHOD assign_student.

    ro_object = NEW #(  ).

  ENDMETHOD.
ENDCLASS.
