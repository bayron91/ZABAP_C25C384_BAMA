CLASS zcl_lab_17_super_discount_bama DEFINITION INHERITING FROM zcl_lab_15_flight_price_bama
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS add_price REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAB_17_SUPER_DISCOUNT_BAMA IMPLEMENTATION.


  METHOD add_price.

    APPEND is_flight TO me->mt_flights.
    LOOP AT me->mt_flights ASSIGNING FIELD-SYMBOL(<lfs_flights>).
      <lfs_flights>-price = ( <lfs_flights>-price * 80 ) / 100.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
