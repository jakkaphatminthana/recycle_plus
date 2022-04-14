import 'package:form_field_validator/form_field_validator.dart';

MultiValidator ValidatorEmpty = MultiValidator([
  RequiredValidator(errorText: "กรุณาป้อนข้อมูลด้วย"),
]);

MultiValidator ValidatorEmail = MultiValidator(
  [
    RequiredValidator(errorText: "กรุณาป้อนอีเมลด้วย"),
    EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
  ],
);

MultiValidator ValidatorPassword = MultiValidator(
  [
    RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านด้วย"),
    MinLengthValidator(6, errorText: "รหัสผ่านต้องไม่ต่ำกว่า 6 ตัว")
  ],
);
