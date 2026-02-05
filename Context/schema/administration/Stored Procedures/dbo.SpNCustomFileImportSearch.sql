
Create Procedure SpNCustomFileImportSearch
	@_TopN int = 250,
	@TenantId bigint,
	@InteractiveUserId bigint,
	@SelectedUserId bigint = 0,
    @IsSuperUser bit = 0,
    @LoEntryDate datetime = null,
	@HiEntryDate datetime = null,
    @OriginalFileName varChar(255) = '',     
    @FileImportType varChar(255) = '',     
    @FileImportHeaderStatus varChar(255) = '' 
As


-- Limit rows returned?          
IF (@_TopN > 0) SET ROWCOUNT @_TopN;

WITH
		cte ( FileImportHeaderId, OriginalFileName, FileImportType, EntryDate, FileImportHeaderStatus, TotalRecords, 
				PercentComplete, ImportedBy, SearchRowNumber, TotalFailedCount)
  AS
  (

Select a.FileImportHeaderId, a.OriginalFileName, a.FileImportType, a.EntryDate, 
	Case When a.[Status] = 'RowsUploaded' And e.EstimatedStartDate Is Not Null 
			-- sql date formating; 120 is date+time; 108 is time
			Then a.[Status] + ' (Est. start time: ' +  	Left(Convert(varchar, e.EstimatedStartDate, 108), 5) + ')' 
		When a.[Status] In ('ProcessingRows') And a.EstimatedRecordsProcessedPerSecond Is Not Null 
			Then a.[Status] + ' (Est. finish time: ' + Left(Convert(varchar, DATEADD(second, (( /*a.NumberOfRecords - */ COUNT(b.FileImportHeaderId)) / a.EstimatedRecordsProcessedPerSecond), getdate()), 108), 5) + ')'
		Else a.[Status] End																			As 'FileImportHeaderStatus',
	IsNull(a.NumberOfRecords, 0)																		As 'TotalRecords', 
	Case When a.[Status] In ('Complete', 'Failed') Then 100
		When COUNT(b.FileImportHeaderId) = 0 Then 0
		Else ROUND(100 - (ROUND( ( COUNT(b.FileImportItemId) / convert(float, a.NumberOfRecords) ) , 4) * 100), 2)
		End																								As 'PercentComplete', 
		ISNULL(d.FirstName,'') + ' ' + ISNULL(d.LastName,'') As ImportedBy, 
		ROW_NUMBER() OVER(ORDER BY a.EntryDate Desc) AS RowNumber,
		ISNULL(NumberOfRecordsFailed,0) + ISNULL(NumberOfRecordsDuplicated,0)							As 'TotalFailedCount'
From TFileImportHeader a with(nolock)
Left Join TFileImportItem b with(nolock)
	on a.FileImportHeaderId = b.FileImportHeaderId
		And a.[Status] Not In ('Complete', 'Failed')
		And b.[Status] In ('AwaitingProcessing')
Join TUser c with(nolock) on a.UserId = c.UserId
Join crm..TCRMContact d with(nolock) on c.CRMContactId = d.CRMContactId
Left Join TFileImportQueuedFile e with(nolock) on a.FileImportHeaderId = e.FileImportHeaderId
Where 1=1
And a.TenantId = @TenantId
And (	(@IsSuperUser = 1 And @SelectedUserId = 0) 
		Or (@IsSuperUser = 1 And @SelectedUserId > 0 And a.UserId = @SelectedUserId) 
		Or (@IsSuperUser = 0 And a.UserId = @InteractiveUserId)
	)
And ( (@LoEntryDate Is Null) Or (@LoEntryDate Is Not Null and a.EntryDate >= @LoEntryDate))
And ( (@HiEntryDate Is Null) Or (@HiEntryDate Is Not Null and a.EntryDate <= @HiEntryDate))
And ( (@OriginalFileName = '') Or (@OriginalFileName <> '' and a.OriginalFileName Like @OriginalFileName + '%'))
And ( (@FileImportType = '') Or (@FileImportType <> '' and a.FileImportType Like @FileImportType))
And ( (@FileImportHeaderStatus = '') Or (@FileImportHeaderStatus <> '' and a.[Status] Like @FileImportHeaderStatus))
Group By a.FileImportHeaderId, a.OriginalFileName, a.FileImportType, a.EntryDate, a.[Status],
	a.NumberOfRecords, d.FirstName, d.LastName, NumberOfRecordsFailed, NumberOfRecordsDuplicated, 
	e.EstimatedStartDate, a.EstimatedRecordsProcessedPerSecond
)

Select SearchRowNumber As 'Id', FileImportHeaderId, OriginalFileName, FileImportType, EntryDate, FileImportHeaderStatus, 
	TotalRecords, PercentComplete, ImportedBy, TotalFailedCount
From cte 

IF (@_TopN > 0) SET ROWCOUNT 0

