CLASS zcl_lab_14_grid_bama DEFINITION INHERITING FROM zcl_lab_13_view_bama
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_box TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_14_grid_bama IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_view_type = 'Grid view' ).
    me->box = iv_box.
  ENDMETHOD.

ENDCLASS.
