CREATE FUNCTION [utl].[IsDanishHoliday]
(
	@date DATE,
	@language INT -- 1 = Dansk, 2 = Engelsk
)
RETURNS @resultable TABLE
(
	[IsHoliday] tinyint NOT NULL,
	[HolidayName] varchar(50) NULL
)
AS
BEGIN
	DECLARE @d int, @m int, @y int, @r tinyint, @e date, @dn varchar(50)
	SELECT @d=day(@date), @m=month(@date), @y=year(@date), @r=0  
	
	IF @language = 1 SET @dn = 'Ikke helligdag'
	ELSE IF @language = 2 SET @dn = 'No public holiday'

	-- faste helligdage  
	IF  (@d = 1 and @m = 1)  -- Nytaarsdag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Nytårsdag' WHEN @language = 2 THEN 'New Year''s Day' ELSE 'Nytårsdag' END)
	IF	(@d = 5 and @m= 6)  -- Grundlovsdag 
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Grundlovsdag' WHEN @language = 2 THEN 'Constitution Day' ELSE 'Grundlovsdag' END)
	IF	(@d = 24 and @m = 12)  -- Juleaftensdag 
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Juleaftensdag' WHEN @language = 2 THEN 'Christmas Eve' ELSE 'Juleaftensdag' END)
	IF	(@d = 25 and @m = 12)  -- 1. juledag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN '1. Juledag' WHEN @language = 2 THEN '1. Christmas Day' ELSE '1. Juledag' END)
	IF	(@d = 26 and @m = 12)  -- 2. juledag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN '2. Juledag' WHEN @language = 2 THEN '2. Christmas Day' ELSE '2. Juledag' END)
	/* yderligere datoer kan indsaettes her  */        
		 
	ELSE BEGIN   
	-- Skaeve helligdage, beregnes udfra Paaske    
	SET @e = utl.CalculateEasterDate(@y)
	IF  (@date = dateadd(day, -7, @e)) -- Palmesoendag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Palmesøndag' WHEN @language = 2 THEN 'Palm Sunday' ELSE 'Palmesøndag' END)
	IF	(@date = dateadd(day, -3, @e)) -- Skaertorsdag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Skærtorsdag' WHEN @language = 2 THEN 'Maundy Thursday' ELSE 'Skærtorsdag' END)
	IF	(@date = dateadd(day, -2, @e)) -- Langfredag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Langfredag' WHEN @language = 2 THEN 'Good Friday' ELSE 'Langfredag' END)
	IF	(@date = dateadd(day,  0, @e)) -- Paaske
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Påske' WHEN @language = 2 THEN 'Easter Sunday' ELSE 'Påske' END)
	IF	(@date = dateadd(day,  1, @e)) -- 2. Paaskedag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN '2. Påskedag' WHEN @language = 2 THEN 'Easter Monday' ELSE '2. Påskedag' END)
	IF	(@date = dateadd(day, 26, @e)) -- St. Bededag
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'St. Bededag' WHEN @language = 2 THEN 'Great Prayer Day' ELSE 'St. Bededag' END)
	IF	(@date = dateadd(day, 39, @e)) -- Kristi Himmelfart
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Kristi Himmelfart' WHEN @language = 2 THEN 'Christ''s ascension' ELSE 'Kristi Himmelfart' END)
	IF	(@date = dateadd(day, 49, @e)) -- Pinse
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN 'Pinse' WHEN @language = 2 THEN 'Whit Sunday' ELSE 'Pinse' END)
	IF	(@date = dateadd(day, 50, @e)) -- 2. Pinsedag      
		SELECT @r = 1, @dn = (CASE WHEN @language = 1 THEN '2. Pinsedag' WHEN @language = 2 THEN 'Whit Monday' ELSE '2. Pinsedag' END)
	END
	INSERT INTO @resultable
	SELECT @r, @dn
	RETURN
END

GO

