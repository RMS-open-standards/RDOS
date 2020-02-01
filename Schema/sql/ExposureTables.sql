
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'RDO')
EXEC sp_executesql N'CREATE SCHEMA RDO AUTHORIZATION dbo;';

CREATE TABLE RDO.ExposureSet(
  id BIGINT NOT NULL,
  name VARCHAR(256) NOT NULL,
  externalId VARCHAR(256),
  description VARCHAR(512),
  createUserId VARCHAR(32),
  createDate DATETIME,
  updateUserId VARCHAR(32),
  updateDate DATETIME
)
;
ALTER TABLE RDO.ExposureSet ADD CONSTRAINT PK_ExposureSet PRIMARY KEY(id);
 
CREATE TABLE RDO.Address(
  id BIGINT NOT NULL,
  addressSchemeId SMALLINT NOT NULL DEFAULT 1,
  exposureSetId BIGINT NOT NULL,
  externalId VARCHAR(256),
  UGId VARCHAR(256),
  source VARCHAR(256),
  latitude FLOAT,
  longitude FLOAT,
  addressText VARCHAR(512),
  campusCorrelationId BIGINT NOT NULL,
  countryCode VARCHAR(4) NOT NULL,
  countryName VARCHAR(256),
  countryGeoId INT,
  countryScheme VARCHAR(6),
  countryModelCode VARCHAR(4),
  zone1Code VARCHAR(16),
  zone1Name VARCHAR(256),
  zone2Code VARCHAR(16),
  zone1GeoId BIGINT,
  zone2Name VARCHAR(256),
  zone2GeoId BIGINT,
  zone3Code VARCHAR(16),
  zone3Name VARCHAR(256),
  zone3GeoId BIGINT,
  zone4Code VARCHAR(16),
  zone4Name VARCHAR(256),
  zone4GeoId BIGINT,
  zone5Code VARCHAR(16),
  zone5Name VARCHAR(256),
  zone5GeoId BIGINT,
  admin1Code VARCHAR(16),
  admin1Name VARCHAR(256),
  admin1GeoId BIGINT,
  admin2Code VARCHAR(16),
  admin2Name VARCHAR(256),
  admin2GeoId BIGINT,
  admin3Code VARCHAR(16),
  admin3Name VARCHAR(256),
  admin3GeoId BIGINT,
  admin4Code VARCHAR(16),
  admin4Name VARCHAR(256),
  admin4GeoId BIGINT,
  admin5Code VARCHAR(16),
  admin5Name VARCHAR(256),
  admin5GeoId BIGINT,
  cityCode VARCHAR(16),
  cityName VARCHAR(256),
  cityGeoId BIGINT,
  cityPreferred VARCHAR(256),
  postalCode VARCHAR(16),
  postalCodeGeoId BIGINT,
  postalCode1GeoId BIGINT,
  postalCode2GeoId BIGINT,
  postalCode3GeoId BIGINT,
  postalCode4GeoId BIGINT,
  locationCode VARCHAR(16),
  locationCodeGeoId BIGINT,
  census1Code VARCHAR(16),
  census1Name VARCHAR(256),
  census1GeoId BIGINT,
  census2Code VARCHAR(16),
  census2Name VARCHAR(256),
  census2GeoId BIGINT,
  streetAddress VARCHAR(256),
  streetIsIntersection VARCHAR(64),
  streetGeoId BIGINT,
  streetType VARCHAR(256),
  parcelName VARCHAR(256),
  parcelNumber VARCHAR(50),
  parcelGeoId BIGINT,
  pointOfInterestFirmName VARCHAR(256),
  pointOfInterestName VARCHAR(256),
  pointOfInterestGeoId BIGINT,
  pointOfInterestType VARCHAR(32),
  buildingId VARCHAR(50),
  buildingName VARCHAR(256),
  buildingGeoId BIGINT,
  unitNumber VARCHAR(64),
  isSubmittedAddress BIT NOT NULL DEFAULT 1,
  geocodingDataSourceId SMALLINT,
  quadKey BIGINT,
  geoProductVersion VARCHAR(20),
  ACORDResolutionCode VARCHAR(64),
  geocodingLocationCode VARCHAR(64),
  geocodingMatchCode VARCHAR(64),
  geoModelResolutionCode SMALLINT,
  geocodingMatchConfidence FLOAT,
  sublocality VARCHAR(256),
  uncertainty FLOAT,
  uncertaintyBuffer FLOAT,
  geoCodedDate DATETIME
);
ALTER TABLE RDO.Address ADD CONSTRAINT PK_Address PRIMARY KEY(id);
ALTER TABLE RDO.Address ADD CONSTRAINT UQ_Address UNIQUE (id, addressSchemeId);
ALTER TABLE RDO.Address ADD CONSTRAINT FK_Address_ExposureSet FOREIGN KEY(exposureSetId) REFERENCES RDO.ExposureSet(id);

-----*** START RISKITEM SUBTYPE  TABLES *** ----
CREATE TABLE RDO.RiskItem(
id BIGINT NOT NULL,
name VARCHAR(256) NOT NULL);

CREATE TABLE RDO.RiskItem_ContainedProperty(
    riskItemId BIGINT NOT NULL,
    externalId VARCHAR(256),
    parentRiskItemId BIGINT,
    name VARCHAR(256) NOT NULL,
    number VARCHAR(256),
    replacementCostValue FLOAT,
    currencyCode CHAR(3)
);
ALTER TABLE RDO.RiskItem_ContainedProperty ADD CONSTRAINT PK_RiskItem_ContainedProperty PRIMARY KEY(riskItemId);

CREATE TABLE RDO.RiskItem_TimeElement (
    riskItemId BIGINT NOT NULL,
    externalId VARCHAR(256),
    name VARCHAR(256) NOT NULL,
    number VARCHAR(256),
    parentRiskItemId BIGINT,
    replacementCostValue FLOAT,
    currencyCode CHAR(3)
);
ALTER TABLE RDO.RiskItem_TimeElement ADD CONSTRAINT PK_RiskItem_TimeElement PRIMARY KEY(riskItemId);

CREATE TABLE RDO.RiskItem_RealProperty(
    riskItemId BIGINT NOT NULL,
    addressId BIGINT NOT NULL,
    externalId VARCHAR(256),
    parentRiskItemId BIGINT,
    name VARCHAR(256) NOT NULL,
    number VARCHAR(256),
	replacementCostValue FLOAT,
	currencyCode CHAR(3),

    buildingHeight FLOAT,
    constructionCompleteDate DATETIME,
    constructionCompletePercent FLOAT,
    constructionSchemeName VARCHAR(10) NOT NULL,
    constructionCode VARCHAR(5) NOT NULL,
    constructionStartDate DATETIME,
  
    floorArea FLOAT,
    floorAreaUnitCode SMALLINT NOT NULL DEFAULT 2,
    floorOccupied VARCHAR(256),
    floorSize FLOAT,
    floorsUnderground SMALLINT,
    footprintArea FLOAT,
    heightUnitCode SMALLINT,
    numberOfBaths SMALLINT,
    numberOfBedrooms SMALLINT,
    numberOfBuildings SMALLINT,
    numberOfStories SMALLINT,
    occupancyschemeName VARCHAR(10) NOT NULL,
    occupancyCode VARCHAR(10) NOT NULL,
    rentalPropertyIdentifierCode SMALLINT,
    secondaryOccupancyList VARCHAR(2048),
    totalRooms INT,
    yearBuilt SMALLINT
);
ALTER TABLE RDO.RiskItem_RealProperty ADD CONSTRAINT PK_RiskItem_RealProperty PRIMARY KEY(riskItemId);
ALTER TABLE RDO.RiskItem_RealProperty ADD CONSTRAINT FK_RiskItem_RealProperty_Address FOREIGN KEY(addressId) REFERENCES RDO.Address(id);


CREATE TABLE RDO.RiskItem_Population(
    riskItemId BIGINT NOT NULL,
    externalId VARCHAR(256),
    parentRiskItemId BIGINT,
    name VARCHAR(256) NOT NULL,
    number VARCHAR(256),
    groupName VARCHAR(256),
    groupNumber VARCHAR(256),
    occupationSchemeName VARCHAR(10) NOT NULL,
    occupationCode INTEGER NOT NULL,
    totalPayroll FLOAT NOT NULL DEFAULT 0.0,
    totalNumPeople INT NOT NULL DEFAULT 0,
    maxNumPeople INT NOT NULL DEFAULT 0,
    calculatedNumPeople INT NOT NULL DEFAULT 0,
    shiftTypeId SMALLINT NOT NULL DEFAULT 0,
    emergencyProtectionProxCode SMALLINT,
    hazardousMaterialCode SMALLINT,
    wageRelativityRankCode SMALLINT,
    riskManagementOnsiteRankCode SMALLINT,
    populationDensityCode SMALLINT,
    USLHCoveredPercent FLOAT,
    hasExcessWorkersComp BIT NOT NULL DEFAULT 0,
    UWManagementAdjustment FLOAT
);
ALTER TABLE RDO.RiskItem_Population ADD CONSTRAINT PK_RiskItem_Population PRIMARY KEY(riskItemId);


CREATE TABLE RDO.PopulationShift(
    riskItemId BIGINT NOT NULL,
    shiftId SMALLINT NOT NULL,
    count INT NOT NULL
);
ALTER TABLE RDO.PopulationShift ADD CONSTRAINT PK_PopulationShift PRIMARY KEY(riskItemId, shiftId);


CREATE TABLE RDO.RealPropertyCharacteristics (
  riskItemId BIGINT NOT NULL,
  characteristicsSchemeCode VARCHAR(32) NOT NULL DEFAULT 'XX',
  basementCode SMALLINT,
  BIPreparednessCode SMALLINT,
  BIRedundancyCode SMALLINT,
  commercialAppurtenantCode SMALLINT,
  contentsVulnWaterCode SMALLINT,
  contentsVulnWindCode SMALLINT, 
  engineeredFoundationCode SMALLINT,
  exteriorCode SMALLINT,
  exteriorRatingCode SMALLINT,
  externalOrnamentationCode SMALLINT,
  fireSprinklerSystemCode SMALLINT,
  fireSuppressionCode SMALLINT,
  fireRemoteAlarmPresenceCode SMALLINT,
  floorTypeCode SMALLINT,
  floodingMissileCode SMALLINT,
  floodingProtectionCode SMALLINT,
  foundationTypeCode SMALLINT,
  frameFoundationConnectionCode SMALLINT,
  garagingCode SMALLINT,
  marineProtectionCode SMALLINT,
  plumbingInsulationCode SMALLINT,
  openingProtectCode SMALLINT,
  performanceCode SMALLINT,
  planIrregularityCode SMALLINT,
  poundingCode SMALLINT,
  residentialAppurtenantCode SMALLINT,
  roofAdditionsCode SMALLINT,
  roofAgeConditionCode SMALLINT,
  roofAnchorCode SMALLINT,
  roofCoveringCode SMALLINT,
  roofGeometryCode SMALLINT,
  roofVentCode SMALLINT,
  structuralUpgradeNonURMCode SMALLINT,
  tankCode SMALLINT,
  URMRetrofitCode SMALLINT,
  URMChimneyCode SMALLINT,
  verticalIrregularityCode SMALLINT,
  windMissileExposureCode TINYINT,
  yearOfUpgrade SMALLINT
 
);
ALTER TABLE RDO.RealPropertyCharacteristics ADD CONSTRAINT PK_RealPropertyCharacteristics PRIMARY KEY(riskItemId);
ALTER TABLE RDO.RealPropertyCharacteristics ADD CONSTRAINT UQ_RealPropertyCharacteristics UNIQUE (riskItemId,characteristicsSchemeCode);

-----*** END RISKITEM SUBTYPE  TABLES *** ----

-----*** START RISK, SCHEDULE  TABLES *** ----

CREATE TABLE RDO.Risk (
    id BIGINT NOT NULL,
    exposureSetId BIGINT NOT NULL,
    primaryRiskItemId BIGINT NOT NULL,
    externalId VARCHAR(256),
    name VARCHAR(256) NOT NULL,
    number VARCHAR(256),
    description VARCHAR(512),
    accountName VARCHAR(256),
    numberOfUnits INTEGER NOT NULL DEFAULT 1
);
ALTER TABLE RDO.Risk ADD CONSTRAINT PK_Risk PRIMARY KEY(id);
ALTER TABLE RDO.Risk ADD CONSTRAINT FK_Risk_ExposureSet FOREIGN KEY(exposureSetId) REFERENCES RDO.ExposureSet(id);

CREATE TABLE RDO.RiskExposure (
  riskExposureId BIGINT NOT NULL,
  exposureSetId BIGINT NOT NULL,
  riskId BIGINT,
  riskItemId BIGINT NOT NULL,
  lossTypeCode VARCHAR(32) NOT NULL,
  insurableInterest FLOAT NOT NULL DEFAULT 1.0
);
ALTER TABLE RDO.RiskExposure ADD CONSTRAINT PK_RiskExposure PRIMARY KEY(riskExposureId);
ALTER TABLE RDO.RiskExposure ADD CONSTRAINT UQ_RiskExposure UNIQUE (riskId, riskItemId, lossTypeCode, insurableInterest);
ALTER TABLE RDO.RiskExposure ADD CONSTRAINT FK_RiskExposure_ExposureSet FOREIGN KEY(exposureSetId) REFERENCES RDO.ExposureSet(id);
ALTER TABLE RDO.RiskExposure ADD CONSTRAINT FK_RiskExposure_Risk FOREIGN KEY(riskId) REFERENCES RDO.Risk(Id);

CREATE TABLE RDO.Schedule (
    id BIGINT NOT NULL,
    exposureSetId BIGINT NOT NULL,
    externalId VARCHAR(256),
    name VARCHAR(256) NOT NULL,
    number VARCHAR(256),
    description VARCHAR(512),
    scheduleExpression VARCHAR(2048),
    accountName VARCHAR(256)
);
ALTER TABLE RDO.Schedule ADD CONSTRAINT PK_Schedule PRIMARY KEY(id);
ALTER TABLE RDO.Schedule ADD CONSTRAINT FK_Schedule_ExposureSet FOREIGN KEY(exposureSetId) REFERENCES RDO.ExposureSet(id);

CREATE TABLE RDO.ScheduleRiskMap (
  scheduleId BIGINT NOT NULL,
  riskId BIGINT NOT NULL
);
ALTER TABLE RDO.ScheduleRiskMap ADD CONSTRAINT PK_ScheduleRiskMap PRIMARY KEY(scheduleId, riskId);
ALTER TABLE RDO.ScheduleRiskMap ADD CONSTRAINT FK_ScheduleRiskMap_Schedule FOREIGN KEY(scheduleId) REFERENCES RDO.Schedule(id);
ALTER TABLE RDO.ScheduleRiskMap ADD CONSTRAINT FK_ScheduleRiskMap_Risk FOREIGN KEY(riskId) REFERENCES RDO.Risk(id);

-----*** END RISK, SCHEDULE  TABLES *** ----

-----*** START CONTRACT  TABLES *** ----

CREATE TABLE RDO.Contract(
  id BIGINT NOT NULL,
  name VARCHAR(256) NOT NULL
);



CREATE TABLE RDO.Contract_Insurance(
  id BIGINT NOT NULL,
  exposureSetId BIGINT NOT NULL,
  externalId VARCHAR(256),
  name VARCHAR(256) NOT NULL,
  number VARCHAR(256),
  description VARCHAR(512),
  statusCode VARCHAR(32),
  insuranceContractTypeCode VARCHAR(32),
  subjectId BIGINT,
  subjectName VARCHAR(256),
  subjectScopeCode VARCHAR(16),
  renewalExternalId VARCHAR(256),
  brokerage FLOAT DEFAULT 0.0
);
ALTER TABLE RDO.Contract_Insurance ADD CONSTRAINT PK_Contract_Insurance PRIMARY KEY(id);
ALTER TABLE RDO.Contract_Insurance ADD CONSTRAINT FK_Contract_Insurance_ExposureSet FOREIGN KEY(exposureSetId) REFERENCES RDO.ExposureSet(id);
ALTER TABLE RDO.Contract_Insurance ADD CONSTRAINT CK_Contract_Insurance_subjectScopeCode CHECK (subjectScopeCode IN ('RISK' , 'SCHEDULE'));


CREATE TABLE RDO.InsuranceLayer (
  id BIGINT NOT NULL,
  externalId VARCHAR(256),
  insuranceContractId BIGINT NOT NULL,
  name VARCHAR(256) NOT NULL,
  number VARCHAR(256),
  description VARCHAR(512),
  inceptionDate DATE,
  expirationDate DATE,
  contractLineOfBusinessCode VARCHAR(32),
  premium FLOAT DEFAULT 0.0,
  premiumCurrencyCode CHAR(3),
  tax FLOAT DEFAULT 0.0,

  payoutShare FLOAT NOT NULL DEFAULT 1.0,
  payoutFunctionCode VARCHAR(32) NOT NULL DEFAULT 'LIMIT',
  payoutAmount FLOAT NOT NULL DEFAULT 0.0,
  payoutAmountBasisCode VARCHAR(32) NOT NULL,
  payoutTimeBasisCode VARCHAR(32) NOT NULL,
  payoutCurrencyCode CHAR(3) NOT NULL,

  excessIsFranchise BIT NOT NULL DEFAULT 0,
  excessAmount FLOAT NOT NULL DEFAULT 0.0,
  excessAmountBasisCode VARCHAR(32) NOT NULL,
  excessTimeBasisCode VARCHAR(32) NOT NULL,
  excessCurrencyCode CHAR(3) NOT NULL,

  lossTypeCode VARCHAR(32) NOT NULL,
  causeOfLossCode VARCHAR(32) NOT NULL,
  subjectId BIGINT,  -- could be another layerId (if parent layer pointing to child) otherwise schedule/riskId
  subjectScopeCode VARCHAR(32) NOT NULL,
  subjectResolutionCode VARCHAR(32)
);

ALTER TABLE RDO.InsuranceLayer ADD CONSTRAINT PK_InsuranceLayer PRIMARY KEY(id);
ALTER TABLE RDO.InsuranceLayer ADD CONSTRAINT UQ_InsuranceLayer UNIQUE(insuranceContractId, name);
ALTER TABLE RDO.InsuranceLayer ADD CONSTRAINT FK_InsuranceLayer_InsuranceContract FOREIGN KEY(insuranceContractId) REFERENCES RDO.Contract_Insurance(id);
ALTER TABLE RDO.InsuranceLayer ADD CONSTRAINT CK_InsuranceLayer_subjectScopeCode CHECK (subjectScopeCode IN ('RISK' , 'SCHEDULE', 'SUBSCHEDULE','LAYER'));


CREATE TABLE RDO.InsuranceTerm(
  id BIGINT IDENTITY,
  insuranceContractId BIGINT NOT NULL,
  termTypeCode VARCHAR(32) NOT NULL,
  amount FLOAT,
  amountBasisCode VARCHAR(32) NOT NULL,
  timeBasisCode VARCHAR(32) NOT NULL,
  currencyCode CHAR(3) NOT NULL,
  lossTypeCode VARCHAR(32) NOT NULL,
  causeOfLossCode VARCHAR(32) NOT NULL,
  subjectId BIGINT,
  subjectScopeCode VARCHAR(32),
  subjectResolutionCode VARCHAR(32)
);
ALTER TABLE RDO.InsuranceTerm ADD CONSTRAINT PK_InsuranceTerm PRIMARY KEY(id);
ALTER TABLE RDO.InsuranceTerm ADD CONSTRAINT FK_InsuranceTerm_InsuranceContract FOREIGN KEY(insuranceContractId) REFERENCES RDO.Contract_Insurance(id);
--ALTER TABLE RDO.InsuranceTerm ADD CONSTRAINT CK_InsuranceContractTerm_subjectScopeCode CHECK (subjectScopeCode IN ('RISK' , 'SCHEDULE', 'SUBSCHEDULE'));

CREATE TABLE RDO.SubscheduleRiskMap (
  subscheduleId BIGINT NOT NULL,
  insuranceContractId BIGINT NOT NULL,
  riskId BIGINT NOT NULL
);
ALTER TABLE RDO.SubscheduleRiskMap ADD CONSTRAINT PK_SubscheduleRiskMap PRIMARY KEY(insuranceContractId, subscheduleId, riskId);
ALTER TABLE RDO.SubscheduleRiskMap ADD CONSTRAINT FK_SubscheduleRiskMap_Risk FOREIGN KEY(riskId) REFERENCES RDO.Risk(id);

CREATE TABLE RDO.Contract_Facultative (
  id BIGINT NOT NULL,
  exposureSetId BIGINT NOT NULL,
  name VARCHAR(256) NOT NULL,
  number VARCHAR(256),
  inceptionDate DATE,
  expirationDate DATE,
  producerCode VARCHAR(80),
  cedantCode VARCHAR(80),
  lossTypeCodes VARCHAR(128) NOT NULL, -- "loss" if no restrictions
  causeOfLossCodes VARCHAR(32) NOT NULL, --"all" if no restrictions
  lineOfBusinessCodes VARCHAR(256),
  premium FLOAT,
  excessAmount FLOAT NOT NULL DEFAULT 0.0,
  excessCurrencyCode CHAR(3) NOT NULL,
  limitAmount FLOAT, -- use for EDM surplus share's occurrence limit
  limitCurrencyCode CHAR(3) NOT NULL,
  share	FLOAT NOT NULL DEFAULT 1.0,
  inuringPriority SMALLINT NOT NULL DEFAULT 1,
);
ALTER TABLE RDO.Contract_Facultative ADD CONSTRAINT PK_Contract_Facultative PRIMARY KEY(id);
ALTER TABLE RDO.Contract_Facultative ADD CONSTRAINT FK_Contract_Facultative_ExposureSet FOREIGN KEY(exposureSetId) REFERENCES RDO.ExposureSet(id);


CREATE TABLE RDO.FacultativeCession (
  id BIGINT NOT NULL,
  facultativeId BIGINT NOT NULL,
  excessAmount FLOAT NOT NULL DEFAULT 0.0,
  excessCurrencyCode CHAR(3) NOT NULL,
  limitAmount FLOAT,
  limitCurrencyCode CHAR(3) NOT NULL,
  share FLOAT NOT NULL DEFAULT 1.0,
  subjectScopeCode VARCHAR(32) NOT NULL, -- "contract", "contractLayer", or "risk"
  subjectInsuranceContractId BIGINT NOT NULL,
  subjectInsuranceLayerId BIGINT,
  subjectRiskId BIGINT
);
ALTER TABLE RDO.FacultativeCession ADD CONSTRAINT PK_FacultativeCession PRIMARY KEY(id);
ALTER TABLE RDO.FacultativeCession ADD CONSTRAINT FK_FacultativeCession_Facultative FOREIGN KEY(facultativeId) REFERENCES RDO.Contract_Facultative(id);
ALTER TABLE RDO.FacultativeCession ADD CONSTRAINT FK_FacultativeCession_InsuranceContract FOREIGN KEY(subjectInsuranceContractId) REFERENCES RDO.Contract_Insurance(id);
ALTER TABLE RDO.FacultativeCession ADD CONSTRAINT FK_FacultativeCession_InsuranceLayer FOREIGN KEY(subjectInsuranceLayerId) REFERENCES RDO.InsuranceLayer(id);
ALTER TABLE RDO.FacultativeCession ADD CONSTRAINT FK_FacultativeCession_Risk FOREIGN KEY(subjectRiskId) REFERENCES RDO.Risk(id);

CREATE TABLE RDO.Contract_Treaty(
  id BIGINT NOT NULL,
  name VARCHAR(256) NOT NULL,
  number VARCHAR(256),
  externalId VARCHAR(256),
  treatyTypeCode VARCHAR(32) NOT NULL,

  depositPremium FLOAT DEFAULT 0.0,
  depositPremiumCurrencyCode CHAR(3),
  taxRate FLOAT DEFAULT 0.0,
  brokerageRate FLOAT DEFAULT 0.0,
  variableExpenseRate FLOAT DEFAULT 0.0,
  lossAdjustmentExpenseRate FLOAT DEFAULT 0.0,
  fixedExpense FLOAT DEFAULT 0.0,

  inuringPriority SMALLINT,
  attachmentLevelCode VARCHAR(32) NOT NULL, -- per_contract/per_contractlayer/per_risk/per_occurrence
  attachmentBasisCode VARCHAR(32) NOT NULL, -- risks attaching/losses occurring
  percentRetention FLOAT NOT NULL DEFAULT 1.0,
  percentShare FLOAT NOT NULL DEFAULT 1.0
);
ALTER TABLE RDO.Contract_Treaty ADD CONSTRAINT PK_Contract_Treaty PRIMARY KEY(id);

CREATE TABLE Rdo.PerRiskTreatySubject (
  id BIGINT NOT NULL,
  treatyId BIGINT NOT NULL,
  portfolioId BIGINT NOT NULL,
  filterAttribute VARCHAR(32), -- contractLineOfBusinessCode or contractCedantCode
  filterValue VARCHAR(80) -- ex: "RES", "COM", "ABC Insurance"
);
ALTER TABLE RDO.PerRiskTreatySubject ADD CONSTRAINT PK_PerRiskTreatySubject PRIMARY KEY(id);

CREATE TABLE RDO.TreatyReinstatements(
  treatyId BIGINT NOT NULL,
  numberOfReinstatements SMALLINT NOT NULL DEFAULT 0,
  isUnlimited BIT NOT NULL DEFAULT 0,
  ordinal SMALLINT NOT NULL DEFAULT 1,
  isPaid BIT DEFAULT 1,
  rate FLOAT DEFAULT 1.0,
  proRataOptionTypeCode VARCHAR(32) -- "Amount", "Time", "Amount_and_Time", ""
);
ALTER TABLE RDO.TreatyReinstatements ADD CONSTRAINT PK_TreatyReinstatements PRIMARY KEY(treatyId);

CREATE TABLE RDO.TreatyLayer(
  treatyId BIGINT NOT NULL,
  id SMALLINT NOT NULL,
  name VARCHAR(256) NOT NULL,
  parentLayerId SMALLINT NOT NULL,
  isPerRisk BIT NOT NULL,
  inceptionDate DATE NOT NULL,
  expirationDate DATE NOT NULL,
  payoutShare FLOAT NOT NULL DEFAULT 1.0,
  payoutFunctionCode VARCHAR(32) NOT NULL DEFAULT 'LIMIT',
  payoutAmount FLOAT NOT NULL DEFAULT 0.0,
  payoutAmountBasisCode VARCHAR(32) NOT NULL,
  payoutTimeBasisCode VARCHAR(32) NOT NULL,
  payoutCurrencyCode CHAR(3) NOT NULL,
  excessIsFranchise BIT NOT NULL DEFAULT 0,
  excessAmount FLOAT NOT NULL DEFAULT 0.0,
  excessAmountBasisCode VARCHAR(32) NOT NULL DEFAULT 'MONEY',
  excessTimeBasisCode VARCHAR(32) NOT NULL,
  excessCurrencyCode CHAR(3) NOT NULL

);
ALTER TABLE RDO.TreatyLayer ADD CONSTRAINT PK_TreatyLayer PRIMARY KEY(id, treatyId);

CREATE TABLE RDO.ContractDeclaration(
  contractId BIGINT NOT NULL,
  contractLayerId BIGINT,
  contractScopeCode VARCHAR(32),   -- 'Layer' or 'Contract'
  contractCedantCode VARCHAR(80),
  reinsurerCode VARCHAR(80),
  underwriterShortName VARCHAR(80),
  producerShortName VARCHAR(80),
  branchShortName VARCHAR(80),
  brokerShortName VARCHAR(80)
  
);
ALTER TABLE RDO.ContractDeclaration ADD CONSTRAINT CK_ContractDeclaration_scopeCode CHECK (contractScopeCode IN ('CONTRACT' , 'LAYER'));


CREATE TABLE RDO.ContractCDL(
  contractId BIGINT NOT NULL,
  CDL VARCHAR(MAX)
);
ALTER TABLE RDO.ContractCDL ADD CONSTRAINT PK_ContractCDL PRIMARY KEY(contractId);

-----*** END CONTRACT  TABLES *** ----


-----*** START PORTFOLIO and PORTFOLIO-CONTRACT MEMBERSHIP *** ----

CREATE TABLE RDO.Portfolio (
    id BIGINT NOT NULL,
    externalId VARCHAR(256),
    name VARCHAR(512) NOT NULL,
	exposureSetId BIGINT,
    number VARCHAR(256),
    portfolioTypeCode VARCHAR(32),
    description VARCHAR(512)
);
ALTER TABLE RDO.Portfolio ADD CONSTRAINT PK_Portfolio PRIMARY KEY(id);
ALTER TABLE RDO.Portfolio ADD CONSTRAINT UQ_Portfolio_name UNIQUE(name);

CREATE TABLE RDO.PortfolioTag (
  portfolioId BIGINT NOT NULL,
  tagCode VARCHAR(32) NOT NULL, -- lineOfBusinessCode, underwriterCode...
  tagValue VARCHAR(80) -- ex: "RES", "Joe", "ABC Insurance"
);

ALTER TABLE RDO.PortfolioTag ADD CONSTRAINT PK_PortfolioTag PRIMARY KEY(portfolioId, tagCode);

CREATE TABLE RDO.PortfolioMembership (
    portfolioId BIGINT NOT NULL,
    insuranceContractId BIGINT NOT NULL
)
;
ALTER TABLE RDO.PortfolioMembership ADD CONSTRAINT PK_PortfolioMembership PRIMARY KEY(portfolioId, insuranceContractId);
ALTER TABLE RDO.PortfolioMembership ADD CONSTRAINT FK_PortfolioMembership_Portfolio FOREIGN KEY(portfolioId) REFERENCES RDO.Portfolio(id);
ALTER TABLE RDO.PortfolioMembership ADD CONSTRAINT FK_PortfolioMembership_InsuranceContract FOREIGN KEY(insuranceContractId) REFERENCES RDO.Contract_Insurance(id);


CREATE TABLE RDO.AggregatePortfolioMembership (
    id BIGINT NOT NULL,
    portfolioId BIGINT NOT NULL,
    exposureSetId BIGINT,
    countryCode VARCHAR(4) NOT NULL,
    admin1Code VARCHAR(16),
    admin2Code VARCHAR(16),
    cresta VARCHAR(16),
    postalCode VARCHAR(16),
    riskCount BIGINT,
    totalReplacementCostValue FLOAT,
    currencyCode CHAR(3) NOT NULL,
    lossTypeCode VARCHAR(32) NOT NULL,
    causeOfLossCode VARCHAR(32) NOT NULL,
    contractLineOfBusinessCode VARCHAR(32),
    totalPremium FLOAT,
    totalLimit FLOAT,
    averageDeductible FLOAT
)
;

ALTER TABLE RDO.AggregatePortfolioMembership ADD CONSTRAINT PK_AggregatePortfolioMembership PRIMARY KEY(id);
ALTER TABLE RDO.AggregatePortfolioMembership ADD CONSTRAINT FK_AggregatePortfolioMembership FOREIGN KEY(portfolioId) REFERENCES RDO.Portfolio(id);
ALTER TABLE RDO.AggregatePortfolioMembership ADD CONSTRAINT FK_AggregatePortfolioMembership_ExposureSet FOREIGN KEY(exposureSetId) REFERENCES RDO.ExposureSet(id);

-----*** END PORTFOLIO and PORTFOLIO MEMBERSHIP *** ----

-----*** START STRUCTURE and STRUCTURE-POSITIONS *** ----

CREATE TABLE RDO.SDLStructure (
    id BIGINT NOT NULL,
    name VARCHAR(512) NOT NULL,
    externalId VARCHAR(256),
    description VARCHAR(512),
    SDL VARCHAR(MAX)
);
ALTER TABLE RDO.SDLStructure ADD CONSTRAINT PK_SDLStructure PRIMARY KEY(id);
ALTER TABLE RDO.SDLStructure ADD CONSTRAINT UQ_SDLStructure_name UNIQUE(name);

CREATE TABLE RDO.StructurePositions (
    id BIGINT NOT NULL,
    structureId BIGINT NOT NULL,
    positionName VARCHAR(512) NOT NULL,
    positionTypeCode VARCHAR(32) NOT NULL,
    children VARCHAR(512),
    instructions VARCHAR(MAX)
)
ALTER TABLE RDO.StructurePositions ADD CONSTRAINT PK_StructurePositions PRIMARY KEY(id);

-----*** END STRUCTURE and STRUCTURE-POSITIONS *** ----