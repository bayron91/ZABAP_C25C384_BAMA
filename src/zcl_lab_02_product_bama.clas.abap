CLASS zcl_lab_02_product_bama DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      set_product IMPORTING iv_product TYPE matnr,
      set_creationdate IMPORTING iv_creation_date TYPE zdate.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: product       TYPE matnr,
          creation_date TYPE zdate.

ENDCLASS.



CLASS ZCL_LAB_02_PRODUCT_BAMA IMPLEMENTATION.


  METHOD set_creationdate.
    creation_date = iv_creation_date.
  ENDMETHOD.


  METHOD set_product.
    product = iv_product.
  ENDMETHOD.
ENDCLASS.
