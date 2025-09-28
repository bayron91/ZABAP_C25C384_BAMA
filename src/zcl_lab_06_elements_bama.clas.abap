CLASS zcl_lab_06_elements_bama DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_elem_objects,
             class     TYPE string,
             instance  TYPE string,
             reference TYPE string,
           END OF ty_elem_objects.

    CONSTANTS: BEGIN OF ty_languages,
                 language1 TYPE string VALUE 'Abap',
                 language2 TYPE string VALUE 'Java',
                 language3 TYPE string VALUE 'Phyton',
                 language4 TYPE string VALUE 'Javascript',
               END OF ty_languages.

    DATA: ms_object TYPE ty_elem_objects.

    METHODS set_object IMPORTING is_object TYPE ty_elem_objects.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_lab_06_elements_bama IMPLEMENTATION.

  METHOD set_object.
    ms_object = is_object.
  ENDMETHOD.

ENDCLASS.
