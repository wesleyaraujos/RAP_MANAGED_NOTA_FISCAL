@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZWAS_NF_HEADER'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_WAS_NF_HEADER
  provider contract transactional_query
  as projection on ZR_WAS_NF_HEADER
  association [1..1] to ZR_WAS_NF_HEADER as _BaseEntity on $projection.DOCNUM = _BaseEntity.DOCNUM
{
  key Docnum,
  Parid,
  Fixed_value,
  _BaseEntity
}
