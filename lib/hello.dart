void main(){
  String s = DateTime.now().toString().substring(0,19);
  String s1 = s.substring(0,4);
  String s2 = s.substring(5,7);
  String s3 = s.substring(8,10);
  String s4 = s.substring(11,13);
  String s5 = s.substring(14,16);
  String s6 = s.substring(17,19);
  String s7 = s1+s2+s3+s4+s5+s6;
  print(int.parse(s7));
}