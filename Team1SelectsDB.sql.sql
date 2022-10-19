USE TEAMPROJECT222
/*1. A list of patients who had appointments at a certain clinic during
a certain time period (for example, all patients who visited Tampa Health Express during 2021).8*/
SELECT ClinicName, AppDate, AppTime, PersonFname, PersonLname
FROM Appointment 
JOIN HealthcareProvider 
ON Appointment.EmpID = HealthcareProvider.EmpID
JOIN Employee
ON Employee.EmpID = HealthcareProvider.EmpID
JOIN Clinics
ON Clinics.ClinicID = Employee.ClinicID
JOIN Person
ON Person.PersonID = Appointment.PatientID
WHERE AppDate BETWEEN 'February 1, 2022' AND 'April 30, 2022' AND ClinicName = 'Memphis Clinic'

/*2. A list of patients who have visited a certain clinic with a particular
ailment (for example, all patients who came in for a sinus infection 
diagnosis).*/
SELECT PersonFname 'PatientFName', PersonLname 'Patient LName', 
	DiagnosisName, ClinicName
FROM Diagnosis
JOIN AppointmentDiagnosis
ON Diagnosis.DiagnosisID = AppointmentDiagnosis.DiagnosisID
JOIN Appointment
ON Appointment.AppID = AppointmentDiagnosis.AppID
JOIN HealthcareProvider
ON HealthcareProvider.EmpID = Appointment.EmpID
JOIN Employee
ON Employee.EmpID = HealthcareProvider.EmpID
JOIN Clinics
ON Employee.ClinicID = Clinics.ClinicID
JOIN Person
ON Person.PersonID = Appointment.PatientID
WHERE DiagnosisName LIKE '%diabetes%'
/*3. A summary for a certain time period showing the count of patients for every diagnosis, displaying the most common 
diagnosis at the top of the list (for example, show a count of patients for every diagnosis seen in 2021).*/
SELECT 
DiagnosisName,
COUNT(PatientID) 'Count of Patients'
FROM Diagnosis
JOIN AppointmentDiagnosis
ON Diagnosis.DiagnosisID = AppointmentDiagnosis.DiagnosisID
JOIN Appointment
ON AppointmentDiagnosis.AppID = Appointment.AppID
WHERE AppDate BETWEEN 'January 1,2022' AND 'December 31, 2022'
GROUP BY DiagnosisName
ORDER BY COUNT(PatientID) DESC

/*4. A billing list of all procedures/services performed for a particular patient during a particular year (include dates, procedure codes,
 procedure names, and procedure prices as well as the first and last name of the healthcare provider who performed the procedures/services).*/
SELECT 
Person.PersonFname 'First Name of HP',
Person.PersonLname 'Last Name of HP',
Patient.PatientID 'Patient Identification',
LabOrder.LabOrderDate 'Order Date',
LabTest.TestCode,
LabTest.TestName 'Name of Test',
LabTest.TestCost 'Price'
FROM LabTest
JOIN LabOrderTest
ON LabTest.LabTestID = LabOrderTest.LabTestID
JOIN LabOrder
ON LabOrderTest.LabOrderID = LabOrder.LabOrderID
JOIN Patient
ON LabOrder.PatientID = Patient.PatientID
JOIN HealthcareProvider
ON HealthcareProvider.EmpID = LabOrder.EmpID
JOIN Employee
ON Employee.EmpID = HealthcareProvider.EmpID
JOIN Person
ON Person.PersonID = Employee.EmpID
WHERE Patient.PatientID = '4' AND Person.PersonFname = 'Sydni'

/*5. A list of all prescriptions, including dates prescribed, medication details, and quantity and frequency prescribed for a 
particular patient searching by patient name (for example, show all medications prescribed for Natasha Veltri).*/
SELECT 
PrescriptionDate 'Date Prescribed',
Quant_Prescribed 'Prescripton Quantity',
Person.PersonFname 'First Name',
Medications.BrandName 'Medication',
Person.PersonLname 'Last Name'
FROM Person
JOIN Patient
ON Person.PersonID = Patient.PatientID
JOIN Prescription
ON Prescription.PatientID = Patient.PatientID
JOIN PrescriptionMedication
ON PrescriptionMedication.PrescriptionID = Prescription.PrescriptionID
JOIN Medications
ON Medications.MedicationCode = PrescriptionMedication.MedicationCode
WHERE Person.PersonLname = 'Green'

/*6. A listing of all clinics in a particular state where a certain procedure/test can be performed (for example, display all clinics in 
Florida where a patient can get an EKG, the patient searches for the term ‘EKG’).*/
SELECT 
Clinics.ClinicState 'State',
ClinicName 'Clinic',
TestName 'Name of Test' 
FROM LabTest
JOIN LabOrderTest
ON LabTest.LabTestID = LabOrderTest.LabTestID
JOIN LabOrder
ON LabOrder.LabOrderID = LabOrderTest.LabOrderID
JOIN Patient
ON Patient.PatientID = LabOrder.PatientID
JOIN Appointment
ON Appointment.PatientID = Patient.PatientID
JOIN AppointmentMedicalInv
ON AppointmentMedicalInv.AppID = Appointment.AppID
JOIN MedicalInventory
ON MedicalInventory.MedInvID = AppointmentMedicalInv.MedInvID
JOIN MedicalClinicInv
ON MedicalClinicInv.MedInvID = MedicalInventory.MedInvID
JOIN Clinics
ON Clinics.ClinicID = MedicalClinicInv.ClinicID
WHERE TestName = 'STD' AND ClinicState = 'Connecticut'

/*7. A list of all lab results for a particular test performed on a particular day, displaying patient name, the name of the lab test,
 the date drawn and the results of the test (for example, all results for COVID test on February 8, 2022).*/
SELECT 
Person.PersonFname 'First Name',
Person.PersonLname 'Last Name',
LabTest.TestName 'Name of Test',
SpecimanLabTest.TestResult 'Results',
Speciman.SpecimanDate 'Speciman Date'
FROM LabTest
JOIN SpecimanLabTest
ON LabTest.LabTestID = SpecimanLabTest.LabTestID
JOIN Speciman
ON Speciman.SpecimanID = SpecimanLabTest.SpecimanID
JOIN Patient
ON Patient.PatientID = Speciman.PatientID
JOIN Person
ON Person.PersonID = Patient.PatientID
WHERE TestName = 'STD'
/*8. A listing of procedures performed during a particular appointment for a patient. Include date of appointment, 
healthcare provider who saw the patient and ordered the procedures (prescribing provider), details and cost of the procedure performed and who performed it.*/ 
SELECT Patient.PatientID, P.PersonFName 'Patient FName',
P.PersonLName 'Patient LName', AppID,
Appointment.AppDate 'Appointment Date',
HP.PersonFname 'HP First Name',
HP.PersonLname 'HP Last Name',
Labtest.TestName 'Test Name',
LabTest.TestCost 'Cost'
FROM Appointment
JOIN HealthcareProvider
ON HealthcareProvider.EmpID = Appointment.EmpID
JOIN Person HP
ON HP.PersonID = HealthcareProvider.EmpID
JOIN LabOrder
ON LabOrder.EmpID = HealthcareProvider.EmpID
JOIN LabOrderTest
ON LabOrderTest.LabOrderID = LabOrder.LabOrderID
JOIN LabTest
ON LabTest.LabTestID = LabOrderTest.LabTestID
JOIN SpecimanLabTest
ON SpecimanLabTest.LabTestID = LabTest.LabTestID
JOIN Patient
ON Patient.PatientID = Appointment.PatientID
JOIN Person AS P
ON P.PersonID = Patient.PatientID
WHERE Patient.PatientID = '3'

/*9. A listing of all the minor patients seen at the clinic and their guardians. Include the names of the minor patient, dates of birth and the names of the guardians.*/
SELECT 
Pat.PersonFName as 'Patient First Name',
Pat.PersonLName as 'Patient Last Name',
Pat.PersonDOB as 'Patient DOB',
Guardian.PersonFName as 'Guardian First Name',
Guardian.PersonLName as 'Guardian Last Name'
FROM PERSON AS Pat
JOIN PATIENT
ON PatientID = Pat.PersonID
JOIN PERSON AS Guardian
ON GuardianID = Guardian.PersonID

/*10. A team custom requirement to support their custom feature/business process.
Show patients emails as well as the date they ordered their lab test as well as the name of the test. Display PatientID, First and Last name, email, and test name.*/
SELECT 
LabOrder.LabOrderDate 'Order Date for Lab',
Patient.PatientID,
Person.PersonFname 'First Name',
Person.PersonLname 'Last Name',
Person.PersonEmail,
LabTest.TestName 'Name of Test'
FROM Person
JOIN Patient
ON Person.PersonID = Patient.PatientID
JOIN LabOrder
ON LabOrder.PatientID = Patient.PatientID
JOIN LabOrderTest
ON LabOrderTest.LabOrderID = LabOrder.LabOrderID
JOIN LabTest
ON LabTest.LabTestID = LabOrderTest.LabTestID
/*11. Display the date a physician received their certification and what hospital 
they are currently working at. Show Physician ID, CertID, Date received and PhysicianHospital.
Use PhysicianCert and Physician. */
SELECT 
Physician.PhysicianID,
CertID,
DateReceived 'Certification Date',
PhysicianHospital 'Hospital'
FROM PhysicianCert
JOIN Physician
ON PhysicianCert.PhysicianID = Physician.PhysicianID

/*12. Display the patients personal information such as their first and last name and street address; include the day they joined the Clinic.
 Show PatientFname, PatientLname, PatientStreet, and PatActiveDate.Use Patient and Person.*/ 
 SELECT 
 PersonFname 'First Name',
 PersonLname 'Last Name',
 Person.PersonStreet 'Street',
 Patient.PatActiveDate 'Active Date for Patient'
 FROM Patient
 JOIN Person
 ON Patient.PatientID = Person.PersonID
 
/*13. Display the quantity prescribed for each Medication brand name. Show Quant_Prescribed, BrandName, and GenericName. 
Use PrescriptionMedication and Medications. */
SELECT 
PrescriptionMedication.Quant_Prescribed 'Quantity',
Medications.BrandName 'Brand Name',
Medications.GenericName 'Generic Name'
FROM PrescriptionMedication
JOIN Medications
ON PrescriptionMedication.MedicationCode = Medications.MedicationCode

/*14. Display the Physician Specialty name for PhysicianID 13. Show PhysicianID, SpecialtyID, and SpecialtyName.
 Use PhysicianSpecialty and Specialties. */
SELECT 
PhysicianSpecialty.PhysicianID 'Physicians Identification',
Specialties.SpecialtyID 'Specialtiy Identification',
Specialties.SpecialtyName 'Specialty Name' 
FROM PhysicianSpecialty
JOIN Specialties
ON PhysicianSpecialty.SpecialtyID = Specialties.SpecialtyID

/*15. Display the patient and the patient's prescriptions that the delivery persons are delivering. Show PatientID, PrescriptionID, and DeliveryPersonID. 
Use DeliveryPerson and PatientDelivery. */
SELECT 
PatientDelivery.PatientID,
PatientDelivery.PrescriptionID,
DeliveryPerson.DeliveryPersonID 
FROM DeliveryPerson
JOIN PatientDelivery
ON DeliveryPerson.DeliveryPersonID = PatientDelivery.DeliveryPersonID