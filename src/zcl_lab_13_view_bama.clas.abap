CLASS zcl_lab_13_view_bama DEFINITION
  PUBLIC
*  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_view_type TYPE string.
    METHODS: get_view_type RETURNING VALUE(rv_view_type) TYPE string,
             get_box RETURNING VALUE(rv_box) TYPE string.

  PROTECTED SECTION.
    DATA: view_type TYPE string,
          box       TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_13_VIEW_BAMA IMPLEMENTATION.


  METHOD constructor.
    me->view_type = iv_view_type.
  ENDMETHOD.


  METHOD get_view_type.
    rv_view_type = me->view_type.
  ENDMETHOD.


  METHOD get_box.
    rv_box = me->box.
  ENDMETHOD.
ENDCLASS.
