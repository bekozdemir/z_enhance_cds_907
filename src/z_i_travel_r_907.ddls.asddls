@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Model View Entity - Read Only'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity Z_I_TRAVEL_R_907
  as select from /DMO/I_Travel_U as Travel
  association [1..1] to /DMO/I_Agency     as _Agency   on $projection.AgencyID = _Agency.AgencyID
  association [1..1] to /DMO/I_Customer   as _Customer on $projection.CustomerID = _Customer.CustomerID
  composition [0..*] of Z_I_BOOKING_R_907 as _Booking2 
{
      @UI           : {
      lineItem      : [{position: 10, importance: #HIGH}]
      }
  
  key TravelID,

      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Agency', element: 'AgencyID'} } ]
      @ObjectModel.text.association: '_Agency'
      AgencyID,

      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Customer', element: 'CustomerID' }}]
      @ObjectModel.text.association: '_Customer'
      CustomerID,

      concat_with_space(_Customer.Title, _Customer.LastName, 1) as Addressee,

      BeginDate,
      EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,

      cast( 'USD' as abap.cuky)                                 as TargetCurrency,
      @Semantics.amount.currencyCode: 'TargetCurrency'
      currency_conversion(
      amount => TotalPrice,
      source_currency => CurrencyCode,
      round => 'X',
      target_currency => cast( 'USD' as abap.cuky ),
      exchange_rate_date => cast('20010101' as abap.dats),
      exchange_rate_type => 'P',
      error_handling => 'SET_TO_NULL')  as PriceInUSD,                       
      
      CurrencyCode,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Memo,

      Status,
      LastChangedAt,
      /* Associations */
      _Agency,
      _Booking,
      _Booking2,
      _Currency,
      _Customer,
      _TravelStatus
}
