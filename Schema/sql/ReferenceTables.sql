
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'REF')
EXEC sp_executesql N'CREATE SCHEMA REF AUTHORIZATION dbo;';

-----------START Address REF Tables------------------

CREATE TABLE REF.AddressScheme (
  addressSchemeId SMALLINT NOT NULL,
  addressSchemeName VARCHAR(32) NOT NULL,
  addressSchemeDesc VARCHAR(256),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.AddressScheme ADD CONSTRAINT PK_AddressScheme PRIMARY KEY(addressSchemeId);

CREATE TABLE REF.Country (
  countryGeoId INTEGER NOT NULL,
  countryCode VARCHAR(4) NOT NULL,
  countryName VARCHAR(256),
  iso2a VARCHAR(4),
  iso3a VARCHAR(4),
  iso3n VARCHAR(4),
  fips VARCHAR(4),
  cresta VARCHAR(6),
  countryModelCode VARCHAR(4),
  countryModelName VARCHAR(256),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.Country ADD CONSTRAINT PK_Country PRIMARY KEY(countryCode);
 ALTER TABLE REF.Country ADD CONSTRAINT UQ_Country UNIQUE(countryGeoId);


CREATE TABLE REF.Admin1 (
  admin1GeoId BIGINT NOT NULL,
  countryGeoId INTEGER,
  admin1Code VARCHAR(16),
  admin1Name VARCHAR(256),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.Admin1 ADD CONSTRAINT PK_Admin1 PRIMARY KEY(admin1GeoId);

CREATE TABLE REF.Admin2 (
  admin2GeoId BIGINT NOT NULL,
  admin1GeoId BIGINT NOT NULL,
  countryGeoId INTEGER,
  admin2Code VARCHAR(16),
  admin2Name VARCHAR(256),
  cresta VARCHAR(16),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.Admin2 ADD CONSTRAINT PK_Admin2 PRIMARY KEY(admin2GeoId);

CREATE TABLE REF.Admin3 (
  admin3GeoId BIGINT NOT NULL,
  admin2GeoId BIGINT NOT NULL,
  admin1GeoId BIGINT NOT NULL,
  countryGeoId BIGINT NOT NULL,
  admin3Code VARCHAR(16),
  admin3Name VARCHAR(256),
  cresta VARCHAR(16),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.Admin3 ADD CONSTRAINT PK_Admin3 PRIMARY KEY(admin3GeoId);

CREATE TABLE REF.Admin4 (
  admin4GeoId BIGINT NOT NULL,
  admin3GeoId BIGINT NOT NULL,
  admin2GeoId BIGINT NOT NULL,
  admin1GeoId BIGINT NOT NULL,
  countryGeoId BIGINT NOT NULL,
  admin4Code VARCHAR(16),
  admin4Name VARCHAR(256),
  cresta VARCHAR(16),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.Admin4 ADD CONSTRAINT PK_Admin4 PRIMARY KEY(admin4GeoId);
 
CREATE TABLE REF.Admin5 (
  admin5GeoId BIGINT NOT NULL,
  admin4GeoId BIGINT NOT NULL,
  admin3GeoId BIGINT NOT NULL,
  admin2GeoId BIGINT NOT NULL,
  admin1GeoId BIGINT NOT NULL,
  countryGeoId BIGINT NOT NULL,
  admin5Code VARCHAR(16),
  admin5Name VARCHAR(256),
  CRESTA VARCHAR(16),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.Admin5 ADD CONSTRAINT PK_Admin5 PRIMARY KEY(admin5GeoId);

CREATE TABLE REF.PostalCode (
  postalCodeGeoId BIGINT NOT NULL,
  admin3GeoId BIGINT NOT NULL,
  admin2GeoId BIGINT NOT NULL,
  admin1GeoId BIGINT NOT NULL,
  countryGeoId BIGINT NOT NULL,
  postalCode VARCHAR(16),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.PostalCode ADD CONSTRAINT PK_PostalCode PRIMARY KEY(postalCodeGeoId);

CREATE TABLE REF.City (
  cityGeoId BIGINT NOT NULL,
  countryGeoId BIGINT NOT NULL,
  cityCode VARCHAR(10),
  cityName VARCHAR(256),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.City ADD CONSTRAINT PK_City PRIMARY KEY(cityGeoId);

CREATE TABLE REF.GeoModelResolution (
 geoModelResolutionCode SMALLINT NOT NULL,
 geoModelResolutionDesc VARCHAR(1024),
 isActive BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.GeoModelResolution ADD CONSTRAINT PK_GeoModelResolution PRIMARY KEY(geoModelResolutionCode);

 CREATE TABLE REF.GeocodingResolution (
 geocodingResolutionCode SMALLINT NOT NULL,
 geocodingResolutionDesc VARCHAR(1024),
 isActive BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.GeocodingResolution ADD CONSTRAINT PK_GeocodingResolution PRIMARY KEY(geocodingResolutionCode);
 
 CREATE TABLE REF.GeocodingDataSource (
 geocodingDataSourceId SMALLINT NOT NULL,
 geocodingDataSourceName VARCHAR(32),
 isActive BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.GeocodingDataSource ADD CONSTRAINT PK_GeocodingDataSource PRIMARY KEY(geocodingDataSourceId);

 -----------END Address REF Tables------------------

------------START CONTRACT/FINANCIAL REF Tables----------
 CREATE TABLE REF.Currency (
    currencyCode CHAR(3) NOT NULL,
    currencyName VARCHAR(256),
    countryName VARCHAR(256),
    currencySymbol NVARCHAR(8),
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.Currency ADD CONSTRAINT PK_Currency PRIMARY KEY(currencyCode);

CREATE TABLE REF.CurrencyExchangeRate (
  currencyCode CHAR(3) NOT NULL,
  effectiveDate DATETIME NOT NULL,
  exchangeRate FLOAT NOT NULL DEFAULT 1.0
);

CREATE TABLE REF.CauseOfLoss (
    causeOfLossCode CHAR(32) NOT NULL,
    causeOfLossDesc VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);

ALTER TABLE REF.CauseOfLoss ADD CONSTRAINT PK_CauseOfLoss PRIMARY KEY(causeOfLossCode);

CREATE TABLE REF.CauseOfLossHierarchy (
    causeOfLossCode CHAR(32) NOT NULL,
    parentCauseOfLossCode CHAR(32) NOT NULL
);
ALTER TABLE REF.CauseOfLossHierarchy ADD CONSTRAINT PK_CauseOfLossHierarchy PRIMARY KEY (causeOfLossCode, parentCauseOfLossCode);
ALTER TABLE REF.CauseOfLossHierarchy ADD CONSTRAINT FK_CauseOfLossHierarchy_CauseOfLoss FOREIGN KEY(causeOfLossCode) REFERENCES REF.CauseOfLoss(causeOfLossCode);
ALTER TABLE REF.CauseOfLossHierarchy ADD CONSTRAINT FK_CauseOfLossHierarchy_CauseOfLoss1 FOREIGN KEY(parentCauseOfLossCode) REFERENCES REF.CauseOfLoss(causeOfLossCode);

CREATE TABLE REF.LossType (
    lossTypeCode VARCHAR(32) NOT NULL,
    lossTypeDesc VARCHAR(1024),
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.LossType ADD CONSTRAINT PK_LossType PRIMARY KEY(lossTypeCode);

CREATE TABLE REF.LossTypeHierarchy (
    lossTypeCode  VARCHAR(32) NOT NULL,
    parentLossTypeCode VARCHAR(32) NOT NULL
);
ALTER TABLE REF.LossTypeHierarchy  ADD CONSTRAINT PK_LossTypeHierarchy  PRIMARY KEY (lossTypeCode, parentLossTypeCode);

 
CREATE TABLE REF.PayoutFunction(
  payoutFunctionCode VARCHAR(32) NOT NULL,
  payoutFunctionDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
);
ALTER TABLE REF.PayoutFunction ADD CONSTRAINT PK_PayoutFunction PRIMARY KEY (payoutFunctionCode);

CREATE TABLE REF.TermType(
  termTypeCode VARCHAR(32) NOT NULL,
  termTypeDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
);
ALTER TABLE REF.TermType ADD CONSTRAINT PK_TermType PRIMARY KEY (termTypeCode);

CREATE TABLE REF.AmountBasis(
  amountBasisCode VARCHAR(32) NOT NULL,
  amountBasisDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
);
ALTER TABLE REF.AmountBasis ADD CONSTRAINT PK_AmountBasis PRIMARY KEY (amountBasisCode);

CREATE TABLE REF.TimeBasis(
  timeBasisCode VARCHAR(32) NOT NULL,
  timeBasisDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
);
ALTER TABLE REF.TimeBasis ADD CONSTRAINT PK_TimeBasis PRIMARY KEY (timeBasisCode);

CREATE TABLE REF.AttachmentBasis (
  attachmentBasisCode VARCHAR(32)  NOT NULL,
  attachmentBasisDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
);

ALTER TABLE REF.AttachmentBasis ADD CONSTRAINT PK_AttachmentBasis PRIMARY KEY (attachmentBasisCode);


CREATE TABLE REF.AttachmentLevel (
  attachmentLevelCode VARCHAR(32)  NOT NULL,
  attachmentLevelDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);

ALTER TABLE REF.AttachmentLevel ADD CONSTRAINT PK_AttachmentLevel PRIMARY KEY (attachmentLevelCode);

CREATE TABLE REF.Resolution (
  resolutionCode VARCHAR(32) NOT NULL,
  resolutionDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.Resolution ADD CONSTRAINT PK_Resolution PRIMARY KEY (resolutionCode);


CREATE TABLE REF.ContractBranch (
    contractBranchCode VARCHAR(80) NOT NULL,
    contractBranchName VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.ContractBranch ADD CONSTRAINT PK_ContractBranch PRIMARY KEY(contractBranchCode);

CREATE TABLE REF.ContractCedant (
    contractCedantCode VARCHAR(80) NOT NULL,
    contractCedantName VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.ContractCedant ADD CONSTRAINT PK_ContractCedant PRIMARY KEY(contractCedantCode);

CREATE TABLE REF.ContractUnderwriter (
    contractUnderwriterCode VARCHAR(80) NOT NULL,
    contractUnderwriterName VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.ContractUnderwriter ADD CONSTRAINT UQ_ContractUnderwriter PRIMARY KEY(contractUnderwriterCode);

CREATE TABLE REF.ContractStatus (
    contractStatusCode CHAR(32) NOT NULL,
    contractStatusDesc VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
        externalId VARCHAR(256)
);
ALTER TABLE REF.ContractStatus ADD CONSTRAINT PK_ContractStatus PRIMARY KEY(contractStatusCode);

CREATE TABLE REF.Insured (
    insuredCode VARCHAR(80) NOT NULL,
    insuredName VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.Insured ADD CONSTRAINT PK_Insured PRIMARY KEY(insuredCode);

CREATE TABLE REF.Insurer (
    insurerCode VARCHAR(80) NOT NULL,
    insurerName VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.Insurer ADD CONSTRAINT PK_Insurer PRIMARY KEY(insurerCode);

CREATE TABLE REF.Reinsurer (
    reinsurerCode VARCHAR(80) NOT NULL,
    reinsurerName VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.Reinsurer ADD CONSTRAINT PK_Reinsurer PRIMARY KEY(reinsurerCode);

CREATE TABLE REF.Producer (
    producerCode VARCHAR(80) NOT NULL,
    producerName VARCHAR(1024) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.Producer ADD CONSTRAINT PK_Producer PRIMARY KEY(producerCode);

CREATE TABLE REF.ContractType (
    contractTypeCode VARCHAR(32) NOT NULL,
    contractTypeDesc VARCHAR(1024) NOT NULL,
    parentContractTypeCode  VARCHAR(32),
    isInsurance BIT,
    isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.ContractType ADD CONSTRAINT PK_ContractType PRIMARY KEY(contractTypeCode);


CREATE TABLE REF.ContractScope (
    contractScopeCode VARCHAR(32) NOT NULL,
    contractScopeDesc VARCHAR(1024),
    isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.ContractScope ADD CONSTRAINT PK_ContractScope PRIMARY KEY(contractScopeCode);

CREATE TABLE REF.ProrataOptionType (
    prorataOptionTypeCode VARCHAR(32) NOT NULL,
    prorataOptionTypeDesc VARCHAR(1024),
    isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.ProrataOptionType ADD CONSTRAINT PK_ProrataOptionType PRIMARY KEY(prorataOptionTypeCode);


CREATE TABLE REF.LineOfBusiness (
    lineOfBusinessCode  VARCHAR(32) NOT NULL,
    lineOfBusinessDesc VARCHAR(256) NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.LineOfBusiness ADD CONSTRAINT PK_LineOfBusiness  PRIMARY KEY(lineOfBusinessCode);

------------END CONTRACT/FINANCIAL REF Tables----------


------------START PORTFOLIO & STRUCTURE REF Tables----------

CREATE TABLE REF.PortfolioType (
    portfolioTypeCode  VARCHAR(32) NOT NULL,
    portfolioTypeDesc VARCHAR(256),
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.PortfolioType ADD CONSTRAINT PK_PortfolioType  PRIMARY KEY(portfolioTypeCode);

CREATE TABLE REF.PositionType (
    positionTypeCode  VARCHAR(32) NOT NULL,
    positionTypeDesc VARCHAR(256) ,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.PositionType ADD CONSTRAINT PK_PositionType  PRIMARY KEY(positionTypeCode);


CREATE TABLE REF.Tag (
    tagCode VARCHAR(32) NOT NULL,
    tagDesc VARCHAR(256) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.Tag ADD CONSTRAINT PK_Tag  PRIMARY KEY(tagCode);

------------END PORTFOLIO & STRUCTURE REF Tables----------

 ------------START REALPROPERTY REF Tables----------

CREATE TABLE REF.RiskitemType (
  riskItemTypeCode VARCHAR(16) NOT NULL,
  riskItemTypeDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.RiskitemType ADD CONSTRAINT PK_RiskitemType PRIMARY KEY (riskItemTypeCode);

CREATE TABLE REF.CharacteristicsScheme (
  characteristicsSchemeCode VARCHAR(16) NOT NULL,
  characteristicsSchemeDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.CharacteristicsScheme ADD CONSTRAINT PK_CharacteristicsScheme PRIMARY KEY (characteristicsSchemeCode);


CREATE TABLE REF.RentalPropertyIdentifier (
  rentalPropertyIdentifierCode INTEGER NOT NULL,
  rentalPropertyIdentifierDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.RentalPropertyIdentifier ADD CONSTRAINT PK_RentalPropertyIdentifier PRIMARY KEY(rentalPropertyIdentifierCode);

CREATE TABLE REF.AreaUnit (
 areaUnitCode TINYINT NOT NULL,
 areaUnitDesc VARCHAR(1024)
);
ALTER TABLE REF.AreaUnit ADD CONSTRAINT PK_AreaUnit PRIMARY KEY(areaUnitCode);

CREATE TABLE REF.Construction (
  constructionschemeName VARCHAR(10) NOT NULL,
  constructionCode VARCHAR(5) NOT NULL,
  constructionName VARCHAR(512) NOT NULL,
  constructionBandName VARCHAR(512),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
);
ALTER TABLE REF.Construction ADD CONSTRAINT PK_Construction PRIMARY KEY(constructionschemeName, constructionCode);

CREATE TABLE REF.DistanceUnit (
 distanceUnitCode TINYINT NOT NULL,
 distanceUnitDesc VARCHAR(1024),
);
ALTER TABLE REF.DistanceUnit ADD CONSTRAINT PK_DistanceUnit PRIMARY KEY(distanceUnitCode);

CREATE TABLE REF.Occupancy (
  occupancyschemeName VARCHAR(10) NOT NULL,
  occupancyCode INTEGER NOT NULL,
  occupancyName VARCHAR(512) NOT NULL,
  occupancyBandName VARCHAR(512),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
);
ALTER TABLE REF.Occupancy ADD CONSTRAINT PK_Occupancy PRIMARY KEY(occupancyschemeName, occupancyCode);

 CREATE TABLE REF.Basement (
  countryGeoId INTEGER NOT NULL,
  optionDesc VARCHAR(1024),
  optionValue SMALLINT NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.Basement ADD CONSTRAINT PK_Basement PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.BIPreparedness (
  countryGeoId INTEGER NOT NULL,
  optionDesc VARCHAR(1024),
  optionValue SMALLINT NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.BIPreparedness ADD CONSTRAINT PK_BIPreparedness PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.BIRedundancy (
  countryGeoId INTEGER NOT NULL,
  optionDesc VARCHAR(1024),
  optionValue SMALLINT NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.BIRedundancy ADD CONSTRAINT PK_BIRedundancy PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.CommercialAppurtenant (
  countryGeoId INTEGER NOT NULL,
  optionDesc VARCHAR(1024),
  optionValue SMALLINT NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.CommercialAppurtenant ADD CONSTRAINT PK_CommercialAppurtenant PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.ContentsVulnWater (
  countryGeoId INTEGER NOT NULL,
  optionDesc VARCHAR(1024),
  optionValue SMALLINT NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.ContentsVulnWater ADD CONSTRAINT PK_ContentsVulnWater PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.ContentsVulnWind (
  countryGeoId INTEGER NOT NULL,
  optionDesc VARCHAR(1024),
  optionValue SMALLINT NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.ContentsVulnWind ADD CONSTRAINT PK_ContentsVulnWind PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.EngineeredFoundation (
  countryGeoId INTEGER NOT NULL,
  optionDesc VARCHAR(1024),
  optionValue SMALLINT NOT NULL,
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
  ALTER TABLE REF.EngineeredFoundation ADD CONSTRAINT PK_EngineeredFoundation PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.Exterior (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );
 ALTER TABLE REF.Exterior ADD CONSTRAINT PK_Exterior PRIMARY KEY(countryGeoId, optionValue);

CREATE TABLE REF.ExteriorRating (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
  );

ALTER TABLE REF.ExteriorRating ADD CONSTRAINT PK_ExteriorRating PRIMARY KEY(countryGeoId, optionValue);

CREATE TABLE REF.ExternalOrnamentation (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

ALTER TABLE REF.ExternalOrnamentation ADD CONSTRAINT PK_ExternalOrnamentation PRIMARY KEY(countryGeoId, optionValue);

CREATE TABLE REF.FireRemoteAlarmPresence (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

ALTER TABLE REF.FireRemoteAlarmPresence ADD CONSTRAINT PK_FireRemoteAlarmPresence PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.FireSprinklerPresence (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

ALTER TABLE REF.FireSprinklerPresence ADD CONSTRAINT PK_FireSprinklerPresence PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.FireSuppression (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

ALTER TABLE REF.FireSuppression ADD CONSTRAINT PK_FireSuppression PRIMARY KEY(countryGeoId, optionValue);

CREATE TABLE REF.FloorType (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.FloorType ADD CONSTRAINT PK_FloorType PRIMARY KEY(countryGeoId, optionValue);

    CREATE TABLE REF.FloodMissile (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.FloodMissile ADD CONSTRAINT PK_FloodMissile PRIMARY KEY(countryGeoId, optionValue);

    CREATE TABLE REF.FloodProtection (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.FloodProtection ADD CONSTRAINT PK_FloodProtection PRIMARY KEY(countryGeoId, optionValue);

    CREATE TABLE REF.FoundationType (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.FoundationType ADD CONSTRAINT PK_FoundationType PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.FrameFoundationConnection (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.FrameFoundationConnection ADD CONSTRAINT PK_FrameFoundationConnection PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.Garaging (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.Garaging ADD CONSTRAINT PK_Garaging PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.MarineProtection (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.MarineProtection ADD CONSTRAINT PK_MarineProtection PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.PlumbingInsulation (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.PlumbingInsulation ADD CONSTRAINT PK_PlumbingInsulation PRIMARY KEY(countryGeoId, optionValue);

CREATE TABLE REF.OpeningProtect (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.OpeningProtect ADD CONSTRAINT PK_OpeningProtect PRIMARY KEY(countryGeoId, optionValue);
  
  CREATE TABLE REF.Performance (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.Performance ADD CONSTRAINT PK_Performance PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.PlanIrregularity (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.PlanIrregularity ADD CONSTRAINT PK_PlanIrregularity PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.Pounding (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.Pounding ADD CONSTRAINT PK_Pounding PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.ResidentialAppurtenant (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.ResidentialAppurtenant ADD CONSTRAINT PK_ResidentialAppurtenant PRIMARY KEY(countryGeoId, optionValue);

  
  CREATE TABLE REF.RoofAdditions (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.RoofAdditions ADD CONSTRAINT PK_RoofAdditions PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.RoofAgeCondition (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.RoofAgeCondition ADD CONSTRAINT PK_RoofAgeCondition PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.RoofAnchor (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.RoofAnchor ADD CONSTRAINT PK_RoofAnchor PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.RoofCovering (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.RoofCovering ADD CONSTRAINT PK_RoofCovering PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.RoofGeometry (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.RoofGeometry ADD CONSTRAINT PK_RoofGeometry PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.RoofVent (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.RoofVent ADD CONSTRAINT PK_RoofVent PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.StructuralUpgradeNonURM (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.StructuralUpgradeNonURM ADD CONSTRAINT PK_StructuralUpgradeNonURM PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.Tank (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.Tank ADD CONSTRAINT PK_Tank PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.URMRetrofit (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

    ALTER TABLE REF.URMRetrofit ADD CONSTRAINT PK_URMRetrofit PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.URMChimney (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

    ALTER TABLE REF.URMChimney ADD CONSTRAINT PK_URMChimney PRIMARY KEY(countryGeoId, optionValue);

 CREATE TABLE REF.VerticalIrregularity (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

    ALTER TABLE REF.VerticalIrregularity ADD CONSTRAINT PK_VerticalIrregularity PRIMARY KEY(countryGeoId, optionValue);

  CREATE TABLE REF.WindMissileExposure (
   countryGeoId INTEGER NOT NULL,
   optionDesc VARCHAR(1024),
   optionValue SMALLINT NOT NULL,
   isActive  BIT DEFAULT 1,
   externalId VARCHAR(256)
  );

  ALTER TABLE REF.WindMissileExposure ADD CONSTRAINT PK_WindMissileExposure PRIMARY KEY(countryGeoId, optionValue);

----END REAL PROPERTY REF tables----------

------------------START POPULATION REF Tables------------
 CREATE TABLE REF.ShiftType (
  shiftTypeId SMALLINT NOT NULL,
  shiftTypeDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.ShiftType ADD CONSTRAINT PK_ShiftType PRIMARY KEY(shiftTypeId);

 CREATE TABLE REF.HazardousMaterial (
  hazardousMaterialCode INTEGER NOT NULL,
  hazardousMaterialDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.HazardousMaterial ADD CONSTRAINT PK_HazardousMaterial PRIMARY KEY(hazardousMaterialCode);

 CREATE TABLE REF.PopulationDensity (
  populationDensityCode INTEGER NOT NULL,
  populationDensityDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.PopulationDensity ADD CONSTRAINT PK_PopulationDensity PRIMARY KEY(populationDensityCode);


 CREATE TABLE REF.WageRelativityRank (
  wageRelativityRankCode SMALLINT NOT NULL,
  wageRelativityRankDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.WageRelativityRank ADD CONSTRAINT PK_WageRelativityRank PRIMARY KEY(wageRelativityRankCode);

 CREATE TABLE REF.RiskManagementOnsiteRank (
  riskManagementOnsiteRankCode SMALLINT NOT NULL,
  riskManagementOnsiteRankDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.RiskManagementOnsiteRank ADD CONSTRAINT PK_RiskManagementOnsiteRank PRIMARY KEY(riskManagementOnsiteRankCode);

 CREATE TABLE REF.EmergencyProtectionProximity (
  emergencyProtectionProxCode SMALLINT NOT NULL,
  emergencyProtectionProxDesc VARCHAR(1024),
  isActive  BIT DEFAULT 1,
 externalId VARCHAR(256)
 );
 ALTER TABLE REF.EmergencyProtectionProximity ADD CONSTRAINT PK_EmergencyProtectionProximity PRIMARY KEY(emergencyProtectionProxCode);

 -------------END START POPULATION REF Tables--------------

 ---------START RESULT Ref Tables---------
 CREATE TABLE REF.Peril (
  perilCode VARCHAR(4) NOT NULL,
  perilDesc VARCHAR(256),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.Peril ADD CONSTRAINT PK_Peril PRIMARY KEY(perilCode);


 CREATE TABLE REF.Region (
  regionCode VARCHAR(4) NOT NULL,
  regionDesc VARCHAR(256),
  isActive  BIT DEFAULT 1,
  externalId VARCHAR(256)
 );
 ALTER TABLE REF.Region ADD CONSTRAINT PK_Region PRIMARY KEY(RegionCode);

 
 CREATE TABLE REF.ResultType (
    resultTypeCode  VARCHAR(32) NOT NULL,
    resultTypeDesc VARCHAR(256),
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.ResultType ADD CONSTRAINT PK_ResultType  PRIMARY KEY(resultTypeCode);

CREATE TABLE REF.SettingsType (
    settingsTypeCode  VARCHAR(32) NOT NULL,
    settingsTypeDesc VARCHAR(256),
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.SettingsType ADD CONSTRAINT PK_SettingsType  PRIMARY KEY(settingsTypeCode);


CREATE TABLE REF.Granularity (
    granularityCode  VARCHAR(32) NOT NULL,
    granularityDesc VARCHAR(256) NOT NULL,
    isActive  BIT DEFAULT 1,
    externalId VARCHAR(256)
);
ALTER TABLE REF.granularity ADD CONSTRAINT PK_Granularity  PRIMARY KEY(granularityCode);

---------END RESULT Ref Tables---------