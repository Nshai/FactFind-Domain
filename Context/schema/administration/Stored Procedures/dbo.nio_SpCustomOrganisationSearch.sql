SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomOrganisationSearch]
	(
		@TenantId bigint,  		
		@LicenseTypeId bigint = 0,	
		@Name varchar(255) = '',
		@Status varchar(255) = ''		
	)

as      
      
      BEGIN

--used for testing purposes
--select @IndClientId = 8

-----------------------------------------------------------------
-- Determine the Hosting FG value for the current indigo client
-----------------------------------------------------------------
DECLARE @HostingFg bit

DECLARE @IsEnabledTrue bit
DECLARE @IsEnabledFalse bit
SET @IsEnabledTrue = 1
SET @IsEnabledFalse = 0


SELECT @HostingFg = (SELECT HostingFg FROM TIndigoClient IC WHERE IC.IndigoClientId = @TenantId)

IF (@HostingFG = 1)

	-----------------------------------------------------------------
	-- If the Hosting FG = 1 then retrieve data for all Indigo Clients
	-----------------------------------------------------------------
	BEGIN

		SELECT	
			IndigoClientId AS [TenantId],
			Identifier AS [Identifier],
			Status  AS [StatusName],
			IOProductType AS [IOProductType],
			IsNetwork AS [IsNetwork],
			
			(select count(* )
				From   TIndigoClientLicense ICL
				Where  IC.IndigoClientId = ICL.IndigoClientId) as TotalLicensedCount,
				
			(select ICL.MaxULAGCount
				From   TIndigoClientLicense ICL
					Where  IC.IndigoClientId = ICL.IndigoClientId
					And ICL.LicenseTypeId = @LicenseTypeId And ICL.Status = 1) as MaxULAGCount,
				
			CASE 
				WHEN (select count(* )
						From   TIndigoClientLicense ICL
						Where  IC.IndigoClientId = ICL.IndigoClientId
						And ICL.LicenseTypeId = @LicenseTypeId And ICL.Status = 1) > 0 THEN @IsEnabledTrue
				ELSE
					@IsEnabledFalse
				END	
               as IsEnabled
		
		FROM	TIndigoClient IC		
		WHERE	(
				((IC.Identifier LIKE '%' + @Name + '%') OR (@Name = ''))
			AND 	((IC.Status = @Status) OR (@Status = ''))
			)

		ORDER BY [TenantId]

	END

ELSE

	BEGIN		

		Declare @IsNetwork bit
		Select @IsNetwork = (SELECT IsNetwork FROM TIndigoClient WHERE IndigoClientId = @TenantId)
	
		IF (@IsNetwork = 1)
			-----------------------------------------------------------------
			-- If the IsNetwork flag = 1 then retrieve data for all Indigo Clients with network id
			-- of current ind client (not including current indigo client)
			-----------------------------------------------------------------		
			BEGIN
		
				SELECT	
					IC2.IndigoClientId AS [TenantId],
					IC2.Identifier AS [Identifier],
					IC2.Status AS [StatusName],
					IC2.IOProductType AS [IOProductType],
					1 AS [IsNetwork],
					
					(select count(* )
						From   TIndigoClientLicense ICL
						Where  IC.IndigoClientId = ICL.IndigoClientId) as TotalLicensedCount,
				
					(select ICL.MaxULAGCount
						From   TIndigoClientLicense ICL
							Where  IC.IndigoClientId = ICL.IndigoClientId
							And ICL.LicenseTypeId = @LicenseTypeId And ICL.Status = 1) as MaxULAGCount,
				
					CASE 
						WHEN (select count(* )
							From   TIndigoClientLicense ICL
							Where  IC.IndigoClientId = ICL.IndigoClientId
							And ICL.LicenseTypeId = @LicenseTypeId And ICL.Status = 1) > 0 THEN @IsEnabledTrue
					ELSE
						@IsEnabledFalse
					END	
					as IsEnabled
					
				FROM TIndigoClient IC
				LEFT JOIN TIndigoClient IC2 ON IC.IndigoClientId = IC2.NetworkId

				WHERE	(
						((IC2.Identifier LIKE '%' + @Name + '%') OR (@Name = ''))
					AND 	((IC2.Status = @Status) OR (@Status = ''))
					AND	((IC.IndigoClientId = @TenantId))
					)				

				ORDER BY [TenantId]

			END

	END 

END
RETURN(0)
GO
