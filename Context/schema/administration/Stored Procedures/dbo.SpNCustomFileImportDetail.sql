Create Procedure SpNCustomFileImportDetail
	@TenantId bigint,
	@FileImportHeaderId varchar(100)
As

/*
 Exec SpNCustomFileImportDetail 10155, 27729, '2C2B0E30-124E-4494-945F-A0A00111A765'
 Exec SpNCustomFileImportDetail 10155, 27729, '0D9AF1B3-D2BB-49FB-906A-A0A0010D3BD1'
 
*/

Select a.FileImportHeaderId, a.OriginalFileName, a.FileImportType, a.EntryDate, a.[Status] as 'FileImportHeaderStatus',
	IsNull(a.NumberOfRecords, 0) As 'TotalRecords', 
	Case When a.[Status] In ('Complete', 'Failed') Then 100
		When COUNT(b.FileImportHeaderId) = 0 Then 0
		Else ROUND( (convert(float, a.NumberOfRecords) / COUNT(b.FileImportHeaderId) ) , 2)
		End As PercentComplete,
		ISNULL(d.FirstName,'') + ' ' + ISNULL(d.LastName,'') As ImportedBy,
		IsNull(a.[Message],'') As Error,
		IsNull(a.NumberOfRecordsFailed,0) As NumberOfRecordsFailed,
		IsNull(a.NumberOfRecordsDuplicated,0) As NumberOfRecordsDuplicated
From TFileImportHeader a with(nolock)
Left Join TFileImportItem b with(nolock)
	on a.FileImportHeaderId = b.FileImportHeaderId
		And a.[Status] Not In ('Complete', 'Failed')
		And b.[Status] In ('AwaitingProcessing')
Join administration..TUser c with(nolock) on a.UserId = c.UserId
Join crm..TCRMContact d with(nolock) on c.CRMContactId = d.CRMContactId
Where TenantId = @TenantId
And a.FileImportHeaderId = @FileImportHeaderId
Group By a.FileImportHeaderId, a.OriginalFileName, a.FileImportType, a.EntryDate, a.[Status],
	a.NumberOfRecords, d.FirstName, d.LastName, a.[Message], a.NumberOfRecordsFailed, a.NumberOfRecordsDuplicated