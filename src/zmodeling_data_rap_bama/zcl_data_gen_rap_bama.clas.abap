CLASS zcl_data_gen_rap_bama DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_data_gen_rap_bama IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM zcustomers_bama.
    DELETE FROM zcustomers_d_bam.

    INSERT zcustomers_bama FROM (
            SELECT FROM /dmo/travel
                FIELDS uuid( ) AS customer_uuid,
                       customer_id,
                       description,
                       createdby AS local_created_by,
                       createdat AS local_created_at,
                       lastchangedby AS local_last_changed_by,
                       lastchangedat AS local_last_changed_at
                 WHERE travel_id BETWEEN 1 AND 1000 ).

    IF sy-subrc EQ 0.
      out->write( |Customers .....{ sy-dbcnt } rows inserted.| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
