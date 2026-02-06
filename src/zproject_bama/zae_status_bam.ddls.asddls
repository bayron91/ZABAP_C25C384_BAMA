@EndUserText.label: 'Form for changed status'
define abstract entity ZAE_STATUS_BAM
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZDD_STATUS_VH',
                                                 element: 'StatusCode' },
                                       useForValidation: true }]
  @EndUserText.label: 'Change Status'
  StatusCode  : zde_status_bam;
  @EndUserText.label: 'Observation Text'
  Observation : abap.char(80);
}
