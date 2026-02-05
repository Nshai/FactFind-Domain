SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomOrganisationSearch]  
	@IndClientId bigint,
	@Name varchar(255) = '',
	@Status varchar(255) = ''
AS


BEGIN

--used for testing purposes
--select @IndClientId = 8

-----------------------------------------------------------------
-- Determine the Hosting FG value for the current indigo client
-----------------------------------------------------------------
DECLARE @HostingFg bit

SELECT @HostingFg = (SELECT HostingFg FROM TIndigoClient IC WHERE IC.IndigoClientId = @IndClientId)

IF (@HostingFG = 1)

	-----------------------------------------------------------------
	-- If the Hosting FG = 1 then retrieve data for all Indigo Clients
	-----------------------------------------------------------------
	BEGIN

		SELECT	1 AS Tag,
			NULL AS Parent,
			IndigoClientId AS [IndigoClient!1!IndigoClientId],
			Identifier AS [IndigoClient!1!Identifier],
			Status  AS [IndigoClient!1!Status],
			IOProductType AS [IndigoClient!1!IOProductType],
			IsNetwork AS [IndigoClient!1!IsNetwork]
		
		FROM	TIndigoClient IC
		
		WHERE	(
				((IC.Identifier LIKE '%' + @Name + '%') OR (@Name = ''))
			AND 	((IC.Status = @Status) OR (@Status = ''))
			)

		ORDER BY [IndigoClient!1!IndigoClientId]

		FOR XML EXPLICIT

	END

ELSE

	BEGIN		

		Declare @IsNetwork bit
		Select @IsNetwork = (SELECT IsNetwork FROM TIndigoClient WHERE IndigoClientId = @IndClientId)
	
		IF (@IsNetwork = 1)
			-----------------------------------------------------------------
			-- If the IsNetwork flag = 1 then retrieve data for all Indigo Clients with network id
			-- of current ind client (not including current indigo client)
			-----------------------------------------------------------------		
			BEGIN
		
				SELECT	1 AS Tag,
					NULL AS Parent,
					IC2.IndigoClientId AS [IndigoClient!1!IndigoClientId],
					IC2.Identifier AS [IndigoClient!1!Identifier],
					IC2.Status AS [IndigoClient!1!Status],
					IC2.IOProductType AS [IndigoClient!1!IOProductType],
					1 AS [IndigoClient!1!IsNetwork]
					
				FROM TIndigoClient IC
				LEFT JOIN TIndigoClient IC2 ON IC.IndigoClientId = IC2.NetworkId

				WHERE	(
						((IC2.Identifier LIKE '%' + @Name + '%') OR (@Name = ''))
					AND 	((IC2.Status = @Status) OR (@Status = ''))
					AND	((IC.IndigoClientId = @IndClientId))
					)				

				ORDER BY [IndigoClient!1!IndigoClientId]

				FOR XML EXPLICIT

			END

	END 

END
RETURN(0)
GO
