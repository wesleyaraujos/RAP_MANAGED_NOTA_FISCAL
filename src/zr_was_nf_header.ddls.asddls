@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZWAS_NF_HEADER'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_WAS_NF_HEADER
  as select from zwas_nf_header
{
  key docnum as Docnum,
  parid as Parid,
  fixed_value as Fixed_value
}
