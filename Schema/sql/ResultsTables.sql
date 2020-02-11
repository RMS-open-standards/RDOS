
--create database RDOSv1;
--use RDOSv1;
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'RDO')
EXEC sp_executesql N'CREATE SCHEMA RDO AUTHORIZATION dbo;';

CREATE TABLE RDO.Settings (
  id BIGINT NOT NULL
);
ALTER TABLE RDO.Settings ADD CONSTRAINT PK_Settings PRIMARY KEY(id);


CREATE TABLE RDO.Settings_ModelProfile (
  id BIGINT NOT NULL,
  analysisType VARCHAR(32) NOT NULL,
  softwareVersion VARCHAR(32) NOT NULL,
  perilCode VARCHAR(32) NOT NULL,
  regionCode VARCHAR(32) NOT NULL,
  currencyCode CHAR(3) NOT NULL,
  currencyAsOfDate DATE,
  modelProfileJson VARCHAR(MAX),
  createUser VARCHAR(32),
  createDate DATETIME);
ALTER TABLE RDO.Settings_ModelProfile ADD CONSTRAINT PK_Settings_ModelProfile PRIMARY KEY(id);

CREATE TABLE RDO.SettingsDetail (
  settingDetailId BIGINT NOT NULL,
  settingId BIGINT NOT NULL,
  settingName VARCHAR(80) NOT NULL,
  settingValue VARCHAR(80) NOT NULL,
  settingGroupName VARCHAR(80),
  settingGroupValue VARCHAR(80));
ALTER TABLE RDO.SettingsDetail ADD CONSTRAINT PK_SettingsDetail PRIMARY KEY(settingDetailId);
ALTER TABLE RDO.SettingsDetail ADD CONSTRAINT UQ_SettingsDetail UNIQUE (settingId,settingName,settingValue,settingGroupName,settingGroupValue);

CREATE TABLE RDO.Settings_RiskAnalysisProfile (
  id BIGINT NOT NULL,
  numberOfPeriods BIGINT NOT NULL,
  currencyCode CHAR(3) NOT NULL,
  currencyAsOfDate DATE,
  reportingWindowStartDate DATE,
  reportingWindowEndDate DATE,
  minimumLossThreshold FLOAT);
ALTER TABLE RDO.Settings_RiskAnalysisProfile ADD CONSTRAINT PK_Settings_RiskAnalysisProfile PRIMARY KEY(id);

CREATE TABLE RDO.Analysis (
  id BIGINT NOT NULL,
  name VARCHAR(128),
  settingsTypeCode VARCHAR(32) NOT NULL,
  settingsId BIGINT NOT NULL
);
ALTER TABLE RDO.Analysis ADD CONSTRAINT PK_Analysis PRIMARY KEY(id,settingsId);

CREATE TABLE RDO.AnalysisHierarchy (
  analysisId BIGINT NOT NULL,
  childAnalysisId BIGINT NOT NULL
);
ALTER TABLE RDO.AnalysisHierarchy ADD CONSTRAINT PK_AnalysisHierarchy PRIMARY KEY(analysisId, childAnalysisId);

CREATE TABLE RDO.AnalysisMap (
  analysisId BIGINT NOT NULL,
  resultsId BIGINT NOT NULL);
ALTER TABLE RDO.AnalysisMap ADD CONSTRAINT PK_AnalysisMap PRIMARY KEY(analysisId, resultsId);

CREATE TABLE RDO.Result (
  id BIGINT NOT NULL);
ALTER TABLE RDO.Result ADD CONSTRAINT PK_Result PRIMARY KEY(id);

CREATE TABLE RDO.ResultMetadata (
  id BIGINT NOT NULL,
  structureId BIGINT NOT NULL,
  positionId BIGINT,
  positionName VARCHAR(512) NOT NULL,
  settingsId BIGINT NOT NULL,
  resultTypeCode VARCHAR(32),
  granularityCode VARCHAR(80));
ALTER TABLE RDO.ResultMetadata ADD CONSTRAINT PK_ResultMetadata PRIMARY KEY(id);


CREATE TABLE RDO.Result_ELT (
  resultId BIGINT NOT NULL,
  facetId BIGINT,
  eventId BIGINT NOT NULL,
  meanLoss FLOAT NOT NULL,
  stdDevC FLOAT NOT NULL,
  stdDevI FLOAT NOT NULL,
  exposureValue FLOAT NOT NULL);
ALTER TABLE RDO.Result_ELT ADD CONSTRAINT PK_Result_ELT PRIMARY KEY(resultId, eventId);

CREATE TABLE RDO.Result_EP (
  resultId BIGINT NOT NULL,
  returnPeriod FLOAT NOT NULL,
  facetId BIGINT,
  aep FLOAT NOT NULL,
  oep FLOAT NOT NULL,
  tce_aep FLOAT NOT NULL,
  tce_oep FLOAT NOT NULL,
  eef FLOAT NOT NULL);
ALTER TABLE RDO.Result_EP ADD CONSTRAINT PK_Result_EP PRIMARY KEY(resultId, returnPeriod);

CREATE TABLE RDO.Result_Stats (
  resultId BIGINT NOT NULL,
  facetId BIGINT,
  aal FLOAT NOT NULL,
  stdDev FLOAT NOT NULL,
  CV FLOAT NOT NULL );
ALTER TABLE RDO.Result_Stats ADD CONSTRAINT PK_Result_Stats PRIMARY KEY(resultId);

CREATE TABLE RDO.Result_PLT (
  resultId BIGINT NOT NULL,
  periodId BIGINT NOT NULL,
  eventId BIGINT NOT NULL,
  facetId BIGINT,
  loss FLOAT NOT NULL,
  lossDate DATE,
  eventDate DATE);
ALTER TABLE RDO.Result_PLT ADD CONSTRAINT PK_Result_PLT PRIMARY KEY(resultId, periodId, eventId);


CREATE TABLE RDO.ResultFacetValues (
  facetId BIGINT NOT NULL,
  admin1GeoId BIGINT,
  admin2GeoId BIGINT,
  admin3GeoId BIGINT,
  postalCodeGeoId BIGINT,
  lineOfBusinessCode VARCHAR(32),
  cedantCode VARCHAR(80));
ALTER TABLE RDO.ResultFacetValues ADD CONSTRAINT PK_ResultFacetValues PRIMARY KEY(facetId);
