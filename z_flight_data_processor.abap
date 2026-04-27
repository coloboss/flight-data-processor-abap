REPORT z_flight_data_processor.

DATA: lt_spfli TYPE TABLE OF spfli,
      ls_spfli TYPE spfli,
      lt_vip   TYPE TABLE OF spfli.

lt_spfli = VALUE #(
  ( carrid = 'LH' connid = 100 )
  ( carrid = 'LH' connid = 250 )
  ( carrid = 'BA' connid = 300 )
  ( carrid = 'AA' connid = 150 )
  ( carrid = 'LH' connid = 400 )
).

"Flights for LH
LOOP AT lt_spfli INTO ls_spfli.
  IF ls_spfli-carrid = 'LH'.
    WRITE: / ls_spfli-carrid, ls_spfli-connid.
  ENDIF.
ENDLOOP.

"Flights with connid >= 250
LOOP AT lt_spfli INTO ls_spfli.
  IF ls_spfli-connid >= 250.
    WRITE: / ls_spfli-connid.
  ENDIF.
ENDLOOP.

"Search for specific flight
READ TABLE lt_spfli INTO ls_spfli
  WITH KEY carrid = 'LH'
           connid = 400.

IF sy-subrc = 0.
  WRITE: / 'Found:', ls_spfli-carrid, ls_spfli-connid.
ELSE.
  WRITE: / 'Flight not found'.
ENDIF.

"Create VIP list
LOOP AT lt_spfli INTO ls_spfli.
  IF ls_spfli-connid > 200.
    APPEND ls_spfli TO lt_vip.
  ENDIF.
ENDLOOP.

"Check if VIP flights exist
IF LINES( lt_vip ) > 0.
  WRITE: / 'VIP flights exist'.
ENDIF.

"Modern filtering (alternative approach)
DATA(lt_vip_modern) = FILTER #( lt_spfli WHERE connid > 200 ).

"Counting VIP flights
DATA(lv_vip_count) = REDUCE i(
  INIT count = 0
  FOR ls_spfli IN lt_spfli
  WHERE ( connid > 200 )
  NEXT count = count + 1
).

WRITE: / 'VIP count:', lv_vip_count.

"Combined condition example
LOOP AT lt_vip INTO ls_spfli.
  IF ls_spfli-carrid = 'LH' AND ls_spfli-connid > 200.
    WRITE: / ls_spfli-carrid, ls_spfli-connid.
  ENDIF.
ENDLOOP.
