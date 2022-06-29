import 'package:untitled1/model/speciality.dart';
import 'package:flutter/cupertino.dart';

List<SpecialityModel> getSpeciality(){

  List<SpecialityModel> specialities = [];
  SpecialityModel specialityModel = new SpecialityModel();

  //1
  specialityModel.noOfDoctors = 10;
  specialityModel.speciality = "Hayvanın Genel Bilgileri";
  specialityModel.imgAssetPath = "assets/img1.png";
  specialityModel.backgroundColor = Color(0xffFBB97C);
  specialities.add(specialityModel);

  specialityModel = new SpecialityModel();

  //2
  specialityModel.noOfDoctors = 17;
  specialityModel.speciality = "Hayvanın Fotoğrafları";
  specialityModel.imgAssetPath = "assets/img2.png";
  specialityModel.backgroundColor = Color(0xffF69383);
  specialities.add(specialityModel);

  specialityModel = new SpecialityModel();

  //3



  return specialities;
}