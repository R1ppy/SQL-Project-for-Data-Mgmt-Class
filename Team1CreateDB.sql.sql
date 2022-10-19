--CREATE DATABASE TEAMPROJECT222
--USE TEAMPROJECT222

CREATE TABLE Person(
	PersonID int Identity (1,1) PRIMARY KEY, 
	PersonFname VARCHAR(35) NOT NULL, 
	PersonLname VARCHAR(35) NOT NULL, 
	PersonStreet VARCHAR(35) NOT NULL, 
	PersonState VARCHAR(35) NOT NULL, 
	PersonCity VARCHAR(15) NOT NULL,
	PersonZipCode CHAR(5) NOT NULL, 
	PersonDOB DATE NOT NULL, 
	PersonGender CHAR(10) NOT NULL, 
	PersonEmail VARCHAR(35) NOT NULL,
	PersonHomePhone CHAR(10) NOT NULL, 
	PersonCellPhone CHAR(10) NOT NULL, 
);


 
CREATE TABLE Clinics (
	ClinicID INT IDENTITY (1,1) PRIMARY KEY,
	ClinicStreet VARCHAR(30) NOT NULL, 
	ClinicState VARCHAR(30) NOT NULL,
	ClinicCity VARCHAR(15) NOT NULL, 
	ClinicZip CHAR(5) NOT NULL, 
	ClinicMainNumber CHAR(10) NOT NULL
	
)
ALTER TABLE Clinics
ADD ClinicName VARCHAR(45);


CREATE TABLE OperationHours (
	OPHoursID CHAR(4) PRIMARY KEY, 
	WeekdayHoursStartTime TIME(7) NOT NULL,
	WeekdayHoursEndTime TIME(7) NOT NULL, 
WeekendHoursStartTime TIME(7) NOT NULL, 
	WeekendHoursEndTime TIME(7) NOT NULL, 
	HolidayHoursStartTime TIME(7) NOT NULL,
	HolidayHoursTimeEnd TIME(7) NOT NULL
);



CREATE TABLE ClinicOperations (
	ClinicOperationsCode CHAR(4) PRIMARY KEY, 
	ClinicID INT ,
	FOREIGN KEY (ClinicID) REFERENCES Clinics (ClinicID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	OPHours Char(4) ,
	FOREIGN KEY (OPHours) REFERENCES OperationHours (OPHoursID)
	ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE Patient(
	PatientID INT PRIMARY KEY,
	PatientInsuranceComp VARCHAR(50) NOT NULL, 
	PatPlanCode CHAR(5) NOT NULL, 
	PatActiveDate DATE not null,
	PatDelivery CHAR(5) NOT NULL,
	GuardianID INT, 
	Foreign key (PatientID) REFERENCES PERSON(PersonID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (GuardianID) REFERENCES PERSON(PersonID)
);



CREATE TABLE DeliveryPerson(    
	DeliveryPersonID INT,
	PRIMARY KEY (DeliveryPersonID),
	FOREIGN KEY (DeliveryPersonID) REFERENCES Person (PersonID)
	ON DELETE CASCADE ON UPDATE CASCADE
); 


CREATE TABLE Employee(
	EmpID int primary key, -- remove identity
	ClinicID int,
	FOREIGN KEY (ClinicID) REFERENCES Clinics (ClinicID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (EmpID) REFERENCES Person (PersonID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)



CREATE TABLE HealthcareProvider (
EmpID int PRIMARY KEY,
	Degree VARCHAR(35) NOT NULL, 
	StateLicenseNO CHAR(10) NOT NULL,
	FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
		ON DELETE CASCADE ON UPDATE CASCADE,
); 



CREATE TABLE Degree (
	DegreeCode CHAR(5) PRIMARY KEY,
	EmpID int 
	FOREIGN KEY (EmpID) REFERENCES HealthcareProvider (EmpID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	DegreeType VARCHAR(35) NOT NULL, 
)


CREATE TABLE Physician(
	PhysicianID INT primary key,
	PhysicianHospital varchar(40) not null,
	FOREIGN KEY (PhysicianID) REFERENCES HealthcareProvider (EmpID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)



CREATE TABLE Certifications(
CertID INT IDENTITY (1,1) PRIMARY KEY,
CertificationName VARCHAR(100) NOT NULL,
)



CREATE TABLE PhysicianCert(
	PhysicianID INT NOT NULL,
	CertID INT NOT NULL,
	DateReceived DATE NOT NULL,
	PRIMARY KEY (PhysicianID, CertID),
	FOREIGN KEY (PhysicianID) REFERENCES Physician (PhysicianID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (CertID) REFERENCES Certifications (CertID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)



CREATE TABLE Specialties(
	SpecialtyID INT IDENTITY PRIMARY KEY,
	SpecialtyName VARCHAR(100) NOT NULL,
)



CREATE TABLE PhysicianSpecialty(
	PhysicianID INT NOT NULL,
	SpecialtyID INT NOT NULL,
	PRIMARY KEY (PhysicianID, SpecialtyID),
	FOREIGN KEY (PhysicianID) REFERENCES Physician (PhysicianID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (SpecialtyID) REFERENCES Specialties (SpecialtyID)		
)



CREATE TABLE Prescription(
	PrescriptionID char(4) PRIMARY KEY, 
	PrescriptionDate DATE NOT NULL, 
	EmpID int 
	FOREIGN KEY (EmpID) REFERENCES HealthcareProvider (EmpID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	PatientID int 
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
	)



CREATE TABLE PatientDelivery (
	PatientDeliveryID Int identity (1,1) primary key,
	DeliveryPersonID INT,
	PatientID int NOT NULL,
	PrescriptionID CHAR(4) NOT NULL,
	DeliveryTime TIME NOT NULL,
	DeliveryDate DATE NOT NULL, 
	DeliveryRoute VARCHAR(35) NOT NULL, 
	FOREIGN KEY (DeliveryPersonID) REFERENCES DeliveryPerson (DeliveryPersonID),
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID),
	FOREIGN KEY (PrescriptionID) REFERENCES Prescription (PrescriptionID)
	)



CREATE TABLE Medications (
	MedicationCode INT IDENTITY (1,1) PRIMARY KEY, 
	BrandName VARCHAR(45) not null, 
	GenericName VARCHAR(45) NOT NULL,
)



CREATE TABLE PrescriptionMedication(
	MedicationCode INT,
	PrescriptionID char(4),
	Quant_Prescribed int not null,
	PRIMARY KEY (PrescriptionID, MedicationCode), --composite PK
	Foreign Key (PrescriptionID) REFERENCES Prescription(PrescriptionID)
	ON UPDATE CASCADE ON DELETE CASCADE, 
	Foreign Key (MedicationCode) REFERENCES Medications(MedicationCode)
	ON UPDATE CASCADE ON DELETE cascade,
);



CREATE TABLE JobHistory(
	JobHistoryID varchar(15) primary key,
	JobTitle varchar(30) not null,
	StartDate date not null,
	EmpID INT,
	FOREIGN KEY (EmpID) REFERENCES Employee (EmpID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)


CREATE TABLE Appointment(
	AppID Char(5) PRIMARY KEY NOT NULL, 
	EmpID int,
	AppTime TIME (7) NOT NULL, 
	AppDate DATE NOT NULL,
	FOREIGN KEY (EmpID) REFERENCES HealthcareProvider (EmpID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	PatientID int 
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
)




CREATE TABLE MedicalInventory(
	MedInvID CHAR(5) NOT NULL PRIMARY KEY,
	MedCategory VARCHAR(50) NOT NULL,
	MedClass VARCHAR(20) NOT NULL,
)



CREATE TABLE AppointmentMedicalInv(
	AppID CHAR(5) NOT NULL,
	MedInvID CHAR(5) NOT NULL,
	EmpID INT,
	PRIMARY KEY (AppID, MedInvID),
	FOREIGN KEY (AppID) REFERENCES Appointment (AppID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (MedInvID) REFERENCES MedicalInventory (MedInvID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (EmpID) REFERENCES HealthcareProvider (EmpID) 		
)



CREATE TABLE MedicalClinicInv(
	ClinicID INT NOT NULL, 
	MedInvID CHAR(5) NOT NULL,
	MedicalPrice smallmoney check (MedicalPrice <= 999.99),
	PRIMARY KEY (ClinicID, MedInvID),
	FOREIGN KEY (ClinicID) REFERENCES Clinics (ClinicID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (MedInvID) REFERENCES MedicalInventory (MedInvID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)



CREATE TABLE Diagnosis(
	DiagnosisID CHAR(5) primary key,
	DiagnosisName VARCHAR(35) NOT NULL,
	DiagnosisDescription VARCHAR(500) NOT NULL
)




CREATE TABLE AppointmentDiagnosis(
	AppID CHAR(5) NOT NULL, 
	DiagnosisID CHAR(5) NOT NULL, 
	PRIMARY KEY (AppID, DiagnosisID),
	FOREIGN KEY (AppID) REFERENCES Appointment (AppID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (DiagnosisID) REFERENCES Diagnosis (DiagnosisID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)




CREATE TABLE MedicationDiagnosis(
	MedicationCode INT NOT NULL,
	DiagnosisCode CHAR(5) NOT NULL,
	PRIMARY KEY (MedicationCode, DiagnosisCode),
	FOREIGN KEY (MedicationCode) REFERENCES Medications (MedicationCode)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (DiagnosisCode) REFERENCES Diagnosis (DiagnosisID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)




CREATE TABLE LabOrder(
	LabOrderID INT IDENTITY, 
	EmpID INT,
	PatientID INT NOT NULL,
	LabOrderDate DATE NOT NULL,  
	PRIMARY KEY (LabOrderID),
	FOREIGN KEY (EmpID) REFERENCES HealthCareProvider (EmpID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)	
)



CREATE TABLE Speciman(
	SpecimanID INT IDENTITY,
	PatientID INT NOT NULL,
	SpecimanTime TIME NOT NULL,
	SpecimanDate DATE NOT NULL,
	PRIMARY KEY (SpecimanID),
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)




CREATE TABLE LabTest( 
	LabTestID CHAR(4) NOT NULL PRIMARY KEY ,
	TestCode VARCHAR(15) NOT NULL,
	TestName VARCHAR(20) NOT NULL, 
	TestCost smallmoney check (TestCost <= 999.99),
)



CREATE TABLE LabOrderTest( 
	LabOrderID INT NOT NULL,
	LabTestID CHAR(4) NOT NULL,
	PRIMARY KEY (LabOrderID, LabTestID),
	FOREIGN KEY (LabOrderID) REFERENCES LabOrder (LabOrderID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (LabTestID) REFERENCES LabTest (LabTestID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)



CREATE TABLE SpecimanLabTest(
	SpecimanID INT NOT NULL,
	LabTestID char(4) NOT NULL,
	TestTime TIME NOT NULL,
	TestDate DATE NOT NULL,
	TestResult VARCHAR(100) NOT NULL,
	PRIMARY KEY (SpecimanID, LabTestID),
	FOREIGN KEY (SpecimanID) REFERENCES Speciman (SpecimanID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (LabTestID) REFERENCES LabTest (LabTestID)
	ON DELETE CASCADE ON UPDATE CASCADE,
)



