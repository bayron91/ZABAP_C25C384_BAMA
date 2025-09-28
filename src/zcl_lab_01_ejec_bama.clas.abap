class zcl_lab_01_ejec_bama definition
  public
  final
  create public .

  public section.
    interfaces if_oo_adt_classrun .

  protected section.
  private section.
endclass.



class zcl_lab_01_ejec_bama implementation.

  method if_oo_adt_classrun~main.

    "Class zcl_lab_10_constructor_bama
    data(lo_constructor) = new zcl_lab_10_constructor_bama(  ).
    out->write( lo_constructor->log ).

  endmethod.

endclass.
