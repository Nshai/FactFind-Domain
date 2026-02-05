SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetPostCodeDistance]
	(@PostCodeLatitudeX1 decimal (18,8),
	@PostCodeLongitudeY1 decimal (18,8),
	@PostCodeLatitudeX2 decimal (18,8),
	@PostCodeLongitudeY2 decimal (18,8))
	RETURNS Decimal (18,8)
AS
BEGIN
	Declare @ReturnValue decimal (18,8)
	Declare @R decimal (18,8)
	Declare @dLat decimal (18,8)
	Declare @dLon decimal (18,8)
	Declare @lat1 decimal (18,8)
	Declare @lat2 decimal (18,8)
	Declare @a decimal (18,8)
	Declare @c decimal (18,8)
	Declare @d decimal (18,8)
	
	Select @R = 6371 /*km*/
	
	Select @dLat = RADIANS(@PostCodeLatitudeX2 - @PostCodeLatitudeX1)
	Select @dLon = RADIANS(@PostCodeLongitudeY2 - @PostCodeLongitudeY1)
	
	Select @lat1 = RADIANS(@PostCodeLatitudeX1)
	Select @lat2 = RADIANS(@PostCodeLatitudeX2)
	
	Select @a = SIN(@dLat/2) * SIN(@dLat/2) + SIN(@dLon/2) * SIN(@dLon/2) * COS(@lat1) * COS(@lat2)
	
	Select @c = 2 * ATN2(SQRT(@a),SQRT(1-@a))
	
	Select @d = @R * @c
	
	Select @ReturnValue = @d
	
	RETURN @ReturnValue
END
GO
