@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel - Interface entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z_I_CUSTOMER_TRAVEL_BAMA
  provider contract transactional_interface
  as projection on Z_R_CUSTOMER_TRAVEL_BAMA
{
  key CustomerUUID,
  key CustomerID,
      //CustomerName,
      Description,
      //CountryName,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _customer
}
