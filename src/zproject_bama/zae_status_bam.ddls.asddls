@EndUserText.label: 'Form for changed status'
define abstract entity ZAE_STATUS_BAM
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZDD_STATUS_VH',
                                                 element: 'StatusCode' },
                                       useForValidation: true }]
  @ObjectModel.text.element: [ 'StatusDescription' ]
  StatusCode        : zde_status_bam;
  @Semantics.text: true
  StatusDescription : abap.char(40);
}
