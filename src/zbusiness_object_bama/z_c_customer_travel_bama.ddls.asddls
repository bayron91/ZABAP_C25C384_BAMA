    @AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel - Consumption entity'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity Z_C_CUSTOMER_TRAVEL_BAMA
  provider contract transactional_query
  as projection on Z_R_CUSTOMER_TRAVEL_BAMA
{
  key CustomerUUID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.text.element: [ 'CustomerName' ]
  key CustomerID,
      _customer.LastName                   as CustomerName,

      Description,

      //localized, get language session user
      _customer._Country._Text.CountryName as CountryName : localized,
      //_customer._Country._Text[1: Language = $session.system_language ].CountryName as CountryName,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _customer
}
