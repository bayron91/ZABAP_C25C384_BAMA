class zcl_lab_10_constructor_bama definition
  public
  final
  create public .

  public section.
    methods constructor.
    class-methods class_constructor.

    class-data log type string.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_LAB_10_CONSTRUCTOR_BAMA IMPLEMENTATION.


  method class_constructor.
    zcl_lab_10_constructor_bama=>log = |{ log } Static constructor-->|.
  endmethod.


  method constructor.
    zcl_lab_10_constructor_bama=>log = |{ log } Instance constructor-->|.
  endmethod.
ENDCLASS.
