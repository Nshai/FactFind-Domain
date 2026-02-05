create table TDashBoardPlanTypeCommissionDN (
	CRMContactID int,
	IndigoClientId int,
	RefPlanTypeId int,
	Amount money)
go
create index IX_TDashBoardPlanTypeCommissionDN_CRMContactID_IndigoClientId_RefPLanTypeId  on TDashBoardPlanTypeCommissionDN (CRMContactID,IndigoClientId,RefPLanTypeId) include (Amount)
go