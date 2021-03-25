class FilterMembers {
  String MembershipId;
  String MemberType;
  String MainMemberId;
  String FirstName;
  String MiddleName;
  String LastGautra;
  String Mobile1;
  String Mobile2;
  String Mobile3;
  String Photo;
  String Education,OtherEducationName;
  String BloodGroup;
  String EmailId;
  String DOB;
  String Relation;
  String ProfessionId;
  String NativeId;
  String NanihalGautra, NanihalNative, NanihalBusiness;
  String SasuralGautra,
      SasuralNative,
      SasuralBusiness,
      Gender,
      Married,
      AniversaryDate;
  String ResidanceAddress,
      ResidanceLandmark,
      ResidenaceCityId,
      ResidanceMobile,
      ResidanceTelephone,
      ResidancePincode;
  String OfficeFirmName,
      OfficeWebsite,
      OfficeEmailId,
      OfficeAddress,
      OfficeLandmark,
      OfficeCityId,
      OfficeMobile,
      OfficeTelephone,
      OfficePincode;
  String NativeOffice,
      NativeLandmark,
      NativeCityId,
      NativeMobile,
      NativeTelephone,
      NativePincode,
      NativeName;
  String RecName1, RecName2, TrusteeName;
  String FormNumber;
  String rcity, rstate, ostate, ocity, nstate, ncity;

  FilterMembers({
    this.rcity,
    this.rstate,
    this.ostate,
    this.ocity,
    this.nstate,
    this.ncity,
    this.MembershipId,
    this.FirstName,
    this.MiddleName,
    this.LastGautra,
    this.Mobile1,
    this.Photo,
    this.Education,
    this.OtherEducationName,
    this.BloodGroup,
    this.EmailId,
    this.DOB,
    this.MemberType,
    this.MainMemberId,
    this.Relation,
    this.Mobile2,
    this.Mobile3,
    this.ProfessionId,
    this.NativeId,
    this.NanihalNative,
    this.NanihalBusiness,
    this.SasuralGautra,
    this.SasuralNative,
    this.Gender,
    this.Married,
    this.AniversaryDate,
    this.ResidanceLandmark,
    this.ResidenaceCityId,
    this.ResidanceMobile,
    this.ResidanceTelephone,
    this.ResidancePincode,
    this.OfficeFirmName,
    this.OfficeWebsite,
    this.OfficeEmailId,
    this.OfficeAddress,
    this.OfficeLandmark,
    this.OfficeCityId,
    this.OfficeMobile,
    this.OfficeTelephone,
    this.OfficePincode,
    this.NativeOffice,
    this.NativeLandmark,
    this.NativeCityId,
    this.NativeMobile,
    this.NativeTelephone,
    this.NativePincode,
    this.NativeName,
    this.RecName1,
    this.RecName2,
    this.TrusteeName,
    this.ResidanceAddress,
    this.SasuralBusiness,
    this.NanihalGautra,
    this.FormNumber,
  });

  factory FilterMembers.fromJson(Map<String, dynamic> json) {
    return FilterMembers(
      MembershipId: json['MembershipId'],
      Relation: json['Relation'],
      FirstName: json['FirstName'],
      MiddleName: json['MiddleName'],
      LastGautra: json['LastGautra'],
      Mobile1: json['Mobile1'],
      Photo: json['Photo'],
      Education: json['Education'],
      OtherEducationName: json['OtherEducationName'],
      BloodGroup: json['BloodGroup'],
      EmailId: json['Emaild'],
      DOB: json['DOB'],
      MemberType: json['MemberType'],
      MainMemberId: json['MainMemberId'],
      Mobile2: json['Mobile2'],
      Mobile3: json['Mobile3'],
      ProfessionId: json['ProfessionId'],
      NativeId: json['NativeId'],
      NanihalGautra: json['NanihalGautra'],
      NanihalNative: json['NanihalNative'],
      NanihalBusiness: json['NanihalBusiness'],
      SasuralGautra: json['SasuralGautra'],
      SasuralNative: json['SasuralNative'],
      SasuralBusiness: json['SasuralBusiness'],
      Gender: json['Gender'],
      Married: json['Married'],
      AniversaryDate: json['AniversaryDate'],
      ResidanceAddress: json['ResidanceAddress'],
      ResidanceLandmark: json['ResidanceLandmark'],
      ResidenaceCityId: json['ResidenaceCityId'],
      ResidanceMobile: json['ResidanceMobile'],
      ResidanceTelephone: json['ResidanceTelephone'],
      ResidancePincode: json['ResidancePincode'],
      OfficeFirmName: json['OfficeFirmName'],
      OfficeWebsite: json['OfficeWebsite'],
      OfficeEmailId: json['OfficeEmailId'],
      OfficeAddress: json['OfficeAddress'],
      OfficeLandmark: json['OfficeLandmark'],
      OfficeCityId: json['OfficeCityId'],
      OfficeMobile: json['OfficeMobile'],
      OfficeTelephone: json['OfficeTelephone'],
      OfficePincode: json['OfficePincode'],
      NativeOffice: json['NativeOffice'],
      NativeLandmark: json['NativeLandmark'],
      NativeCityId: json['NativeCityId'],
      NativeMobile: json['NativeMobile'],
      NativeTelephone: json['NativeTelephone'],
      NativePincode: json['NativePincode'],
      NativeName: json['NativeName'],
      RecName1: json['RecName1'],
      RecName2: json['RecName2'],
      TrusteeName: json['TrusteeName'],
      FormNumber: json['FormNumber'],
      rcity: json['rcity'],
      rstate: json['rstate'],
      ostate: json['ostate'],
      ocity: json['ocity'],
      nstate: json['nstate'],
      ncity: json['ncity'],
    );
  }
}
