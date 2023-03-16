@AbapCatalog.viewEnhancementCategory: [#NONE]
@AbapCatalog.sqlViewName: 'Z_BPA'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Read-only view from /DMO/I_BOOKING_U'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Metadata.allowExtensions: true
@Search.searchable: true

/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view Z_I_BOOKING_R_907
  as select from /DMO/I_Booking_U
  association        to parent Z_I_TRAVEL_R_907 as _Travel     on $projection.TravelID = _Travel.TravelID
  association [1..1] to /DMO/I_Connection       as _Connection on $projection.ConnectionID = _Connection.ConnectionID


{

  key TravelID,
      @Search.defaultSearchElement: true
  key BookingID,
      @Search.defaultSearchElement: true
      BookingDate,
      CustomerID,
      AirlineID,
      ConnectionID,
      FlightDate,

      @Semantics.amount.currencyCode: 'Currency_Code'
      FlightPrice              as Flight_Price,

      @Semantics.currencyCode: true
      CurrencyCode             as Currency_Code,

      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      _Connection.Distance     as Distance,

      @Semantics.unitOfMeasure: true
      _Connection.DistanceUnit as DistanceUnit,
      case
      when _Connection.Distance >= 2000 then 'long-haul flight'
      when _Connection.Distance >= 1000 and
      _Connection.Distance <  2000 then 'medium-haul flight'
      when _Connection.Distance <  1000 then 'short-haul flight'
                      else 'error'
      end                      as Flight_type,




      /* Associations */
      _BookSupplement,
      _Carrier,
      _Connection,
      _Customer,
      _Travel

}
where
  _Connection.DistanceUnit = 'KM'
