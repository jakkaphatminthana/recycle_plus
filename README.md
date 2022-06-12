<div id="top"></div>

# Recycle-Plus
- แอปพลิเคชั่นบนระบบ Android 
- ใช้ฐานข้อมูลบน Firebase
- ผสานการทำงานร่วมกันบนเครือข่าย Blockchain (xCHAIN) 
- [ขอบเขตการวิจัย](https://github.com/jakkaphatminthana/recycle_plus/files/8468961/default.pdf)

## รายละเอียด
- :heavy_check_mark: คือ ทำเเล้ว
- :x: คือ ยังไม่ได้ทำเเละจำเป็นต้องทำ
- :warning: คือ ยังไม่ได้ทำและไม่จำเป็นต้องทำตอนนี้

## สารบัญงาน
- หน้าจอของผู้ใช้
    - <p><a href="#Actor1"> Actor 1 : ผู้ใช้งานที่ไม่มีบัญชี </a></p>
    - <p><a href="#Actor2"> Actor 2 : ผู้ใช้งานที่ยังไม่ได้ยืนยันตัวตน </a></p>
    - <p><a href="#Actor3"> Actor 3 : สมาชิก </a></p>
    - <p><a href="#Actor4"> Actor 4 : สปอนเซอร์ </a></p>
    - <p><a href="#Actor5"> Actor 5 : ผู้ดูแลระบบ </a></p>
- <p><a href="#other"> ระบบเบื้องหลัง </a></p>
    


<p align="right">(<a href="#top">back to top</a>)</p>

<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor1"></div>

## Actor 1 : ผู้ใช้งานที่ไม่มีบัญชี

### หน้าเริ่มต้น
<img src="https://user-images.githubusercontent.com/58208814/165306608-153c7828-87bf-4e4e-b5de-f811cdb639a9.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :x: กดปุ่มแล้วไปที่ หน้าแรก

### หน้าโปรดเข้าสู่ระบบ
<img src="https://user-images.githubusercontent.com/58208814/165307081-6c5ecb55-02be-415a-9213-7f998bda5c11.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: กดปุ่ม "Login" แล้วไปยัง "หน้าเข้าสู่ระบบ" 
- :heavy_check_mark: กดปุ่ม "Back" แล้วไปยังหน้าที่แล้ว

### หน้าเข้าสู่ระบบ
<img src="https://user-images.githubusercontent.com/58208814/165306626-775134d8-69dc-47c5-945f-44c74c56aebe.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: กดไอคอน "สมัครสมาชิก" แล้วไปยัง "หน้าสมัครสมาชิก" 
- :heavy_check_mark: กดไอข้อความ "forgot password" แล้วไปยัง "หน้าลืมรหัสผ่าน" 
- :warning: กดไอคอน "Google" แล้วไปยัง "การล็อคอินผ่าน Google" 
- :heavy_check_mark: กดปุ่ม "Login" แล้วไปยัง "หน้าเข้าสู่ระบบสำเร็จ" 
- :heavy_check_mark: เชื่อมต่อ Firebase Authentication
- :heavy_check_mark: ล็อคอินผ่าน Firebase
- :heavy_check_mark: validation from input 
    - :heavy_check_mark: validation from email 
    - :heavy_check_mark: validation from password
    - :heavy_check_mark: แสดงข้อความ Error
- :heavy_check_mark: validation login error
    - :heavy_check_mark: validation email ต้องมีในระบบ
    - :heavy_check_mark: validation password ต้องเมตซ์กัน
    - :heavy_check_mark: แสดงข้อความ Error

### หน้าสมัครสมาชิก
<img src="https://user-images.githubusercontent.com/58208814/165306639-123ee1b3-1ab6-4b18-a278-ba4f04dd2f70.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: กดข้อความ "เข้าสู่ระบบ" แล้วไปยัง "หน้าเข้าสู่ระบบ" 
- :heavy_check_mark: กดปุ่ม "Register" แล้วไปยัง "หน้าสมัครสมาชิกสำเร็จ" 
- :heavy_check_mark: เชื่อมต่อ Firebase Authentication
- :heavy_check_mark: สมัครสมาชิกผ่าน Firebase
- :heavy_check_mark: validation from input 
    - :heavy_check_mark: validation from email 
    - :heavy_check_mark: validation from password
    - :heavy_check_mark: แสดงข้อความ Error
- :heavy_check_mark: register error report
    - :heavy_check_mark: validation email ห้ามซ้ำ
    - :heavy_check_mark: validation password ห้ามน้อยกว่า 6 ตัว
    - :heavy_check_mark: แสดงข้อความ Error

### หน้าลืมรหัสผ่าน
<img src="https://user-images.githubusercontent.com/58208814/165306651-4205111e-1f87-45f6-b475-e157d0f62210.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: กดไอคอน "Back" แล้วไปยังหน้าที่แล้ว 
- :heavy_check_mark: เชื่อมต่อ Firebase Authentication
- :heavy_check_mark: validation from input 
    - :heavy_check_mark: validation from email 
- :heavy_check_mark: กดปุ่ม "Send" แล้วมี Pop-up ว่าส่งให้แล้วไปดูในอีเมล
- :heavy_check_mark: ในหน้า Pop-up กดตกลงแล้ว ส่งลิงค์รีเช็ตรหัสทาง Gmail แล้วกลับไปยังหน้าที่แล้ว


### หน้าสมัครสมาชิกสำเร็จ
<img src="https://user-images.githubusercontent.com/58208814/165306658-eca19532-66f9-4e54-9744-657a1be62068.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: กดปุ่ม "Back to login" แล้วไปยัง "หน้าเข้าสู่ระบบ" 

### หน้าเข้าสู่ระบบสำเร็จ
<img src="https://user-images.githubusercontent.com/58208814/165306670-a0f7acb5-0afc-477a-ae28-4476eaa787c9.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: กดปุ่ม "Back to home" แล้วไปยัง "หน้าแรก" 
- :heavy_check_mark: ตรวจสอบ role ของ user จากฐานข้อมูล member
    - :heavy_check_mark: หากมี role เป็น member หรือ sponsor ให้ไปหน้าแรกของสมาชิก
    - :heavy_check_mark: หากมี role เป็น admin ให้ไปหน้าแรกของแอดมิน
    - :warning: มีข้อความยินดีต้อนรับ "ชื่อผู้ใช้"

### หน้าแรก (ผู้ใช้ทั่วไป)
<img src="https://user-images.githubusercontent.com/58208814/173233782-1fb4704e-455b-4b8c-b8d4-6b529c08809f.PNG-" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :x: ตรวจสอบสถานะการ login
    - :x: false = ไม่สามารถกดเมนูบน ข่าวสารได้ หากกดแล้วจะไปยัง "หน้าโปรดล็อคอิน" 
    - :x: false = ไม่สามารถกดเมนูบน Appbar ได้หากกดแล้วจะไปยัง "หน้าโปรดล็อคอิน"
- :heavy_check_mark: สามารถกด Tabbar
- :heavy_check_mark: สามารถเข้าดูรายละเอียด ข่าวสารได้
- :warning: Wallet จะต้องไม่แสดงอะไร
- :heavy_check_mark: ดึงข้อมูล Sponsor จาก Firebase มาแสดง 
- :heavy_check_mark: ดึงข้อมูล ข่าวสาร จาก Firebase มาแสดง 
- :heavy_check_mark: สามารถดูโปรไฟล์
- :x: ใช้งานแสกน QR code

### หน้าอ่านข่าว 
<img src="https://user-images.githubusercontent.com/58208814/172160562-6da4e957-73ef-4269-9503-4fc513ebf0b8.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อ Firebase
    - :heavy_check_mark: ดึงข้อมูลภาพมาแสดง
    - :heavy_check_mark: ทำให้เนื้อหาข่าว ขึ้นบรรทัดเอง auto
    - :warning: แสดงยอดวิว
    - :warning: ได้รับ XP. หากอ่านจบถึงล่างสุดของหน้า

### หน้าอัตราแลกเปลี่ยนขยะ (ผู้ใช้ทั่วไป)
<img src="https://user-images.githubusercontent.com/58208814/173234160-74cb0523-2e30-494f-89e7-e6c1311d1283.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อ Firebase
    - :heavy_check_mark: แสดงข้อมูล token, exp
    - :heavy_check_mark: การแสดงข้อมูลต้องเป็นเป็น Strame
- :heavy_check_mark: ลักษณะขยะ auto new line แค่ 2 บรรทัด
    
### หน้าโปรไฟล์ (ผู้ใช้ทั่วไป)
<img src="https://user-images.githubusercontent.com/58208814/173234159-0a39c7ba-b720-4e9f-a266-305c7eeb7cf1.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :x: เชื่อมต่อ Firebase
    - :x: แสดงข้อมูล Name, Email, รูปภาพ
    - :x: แสดงข้อมูล จำนวน Level
    - :x: แสดงสถานะการยืนยันตัวตน
        - :x: ถ้ายังไม่ยืนยันให้สามารถกด เข้ามาทำการยืนยันได้
        - :x: ถ้ายืนยันแล้ว ให้แสดงเฉยๆ
- :x: เมนูต่างๆ กดได้
- :x: Sign out ออกระบบได้
- :x: แก้ไขข้อมูลโปรไฟล์ได้
- :x: เช็คว่าเป็นเจ้าของ user หรือไม่ด้วย
- :x: แสดงข้อมูล Wallet

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor2"></div>

## Actor 2 : ผู้ใช้งานที่ยังไม่ได้ยืนยันตัวตน

<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor3"></div>

## Actor 3 : สมาชิก

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor4"></div>

## Actor 4 : สปอนเซอร์

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor5"></div>

## Actor 5 : ผู้ดูแลระบบ

### หน้าแผงควบคุม (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/172160618-cb827221-5808-46c8-8a48-cda18dc185e1.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: Tabbar Menu
- :x: กดเมนู "Amount of Garbage" แล้วไป "หน้าข้อมูลขยะในระบบ"
- :x: กดเมนู "Pettion List" แล้วไป "หน้ารายการคำร้อง"
- :x: กดเมนู "Misson List" แล้วไป "หน้ารายการภารกิจ"
- :heavy_check_mark: กดเมนู "Member" แล้วไป "หน้าข้อมูลสมาชิกในระบบ"
- :x: กดเมนู "Verify" แล้วไป "หน้าตรวจสอบการยืนยันตัวตน"
- :heavy_check_mark: กดไอคอน "Setting" แล้วไปยัง "หน้าตั้งค่า"
- :warning: ตรวจสอบสถานะ login" ถ้าเป็น false ให้ไปล็อคอิน

### หน้าข้อมูลสมาชิกในระบบ (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/167799091-fb1ce18b-a892-4c0e-805c-4e469425c99d.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อข้อมูล Firebase
    - :heavy_check_mark: แสดงรายการ users
    - :heavy_check_mark: คลิกรายการนั้นแล้ว ไปยังหน้า Detail ตาม ID user
    - :warning: แบ่งหน้าข้อมูลทีละ 15 รายการก่อนค่อย load more
- :heavy_check_mark: กดค้นหาได้ และไป "หน้าค้นหาสมาชิก"

### หน้าค้นหาข้อมูลสมาชิก (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/167851739-00882c94-6fb8-4476-a0c6-ea3d4cd09b58.PNG" width="250"> <img src="https://user-images.githubusercontent.com/58208814/167851751-a2ab42be-cf73-44b2-b02c-ea13acf60619.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อข้อมูล Firebase
    - :heavy_check_mark: แสดงรายการ users ตามคำ word
    - :heavy_check_mark: คลิกรายการนั้นแล้ว ไปยังหน้า Detail ตาม ID user
    - :heavy_check_mark: หากไม่พบข้อมูลที่ตรง word ให้แจ้งบอก
- :heavy_check_mark: กดล้างค่า input ที่ป้อนโดยกด Icon close

### หน้าข้อมูลสมาชิกในระบบ (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/168743056-eb15ac24-45d6-4b4e-9714-43454ddea694.PNG" width="250"> <img src="https://user-images.githubusercontent.com/58208814/168743065-3cdeafb5-2dbe-4bc6-ab0d-87fff7c575ac.PNG" width="250">
 
#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อข้อมูล Firebase
    - :heavy_check_mark: แสดงข้อมูล name, email
    - :heavy_check_mark: แสดงสถานะ role 
    - :warning: แสดงสถานะ verify
    - :warning: แสดงสถานะ verify
- :x: สามารถลบข้อมูลนี้ทิ้งได้ พร้อมกด confrim
- :heavy_check_mark: สามารถแก้ไขข้อมูลนี้ ไปยังหน้าแก้ไข
- :warning: เมนูเพิ่มเติมกดแล้วไปยังหน้านั้นๆ
    - :warning: เมนูรายละเอียดโปรไฟล์
    - :warning: เมนูประวัติการใช้งาน
    - :warning: เมนูประวัติการแลกของรางวัล

### หน้าแก้ไขข้อมูลสมาชิก (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/168743093-ee4cc952-f9e1-4561-b5bb-e95e63d0529c.PNG" width="250"> <img src="https://user-images.githubusercontent.com/58208814/168743087-1fdee1a5-3e5d-42de-88de-e73fdaf71421.PNG" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อข้อมูล Firebase
    - :heavy_check_mark: แสดงข้อมูล email อันเดิม
    - :heavy_check_mark: แสดงข้อมูล role อันเดิม
    - :heavy_check_mark: แสดงสถานะ รูปภาพ อันเดิม
- :heavy_check_mark: สามารถกดเข้าถึงรูปภาพจากเครื่อง
    - :heavy_check_mark: อัปโหลดรูปภาพจาก เครื่อง
    - :heavy_check_mark: อัปโหลดรูปภาพจาก google drive
    - :heavy_check_mark: อัปโหลดรูปภาพจาก google photo
- :heavy_check_mark: เมื่อกดปุ่ม Update
    - :heavy_check_mark: ตรวสอบข้อมูลว่า ค่าว่างไหม
    - :heavy_check_mark: สามารถอัปเดตข้อมูลลง Firebase แล้วไปหน้า "รายละเอียดสมาชิก"


### หน้าข่าวสาร (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/171413602-23bef5a3-8f2c-4f1a-b4af-66ed4db188a6.PNG" width="250"> 

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อข้อมูล Firebase
    - :heavy_check_mark: แสดงรายการข่าวสาร
    - :heavy_check_mark: convert time 
    - :warning: กำหนดให้แสดงข้อมูลก่อน 10 อันแล้วค่อย กดดูเพิ่มเติม
- :heavy_check_mark: ควบคุม widget
    - :heavy_check_mark: titile เมื่อเกิน 30 คำให้เติม ...
    - :heavy_check_mark: content ขึ้นบรรทัดใหม่ auto และเมื่อเกินให้เติม ...
- :heavy_check_mark: กดรายการข่าวแล้วไป "หน้าแก้ไขข่าวสาร" โดยส่ง ID ไปอ้างอิง
- :heavy_check_mark: กดเพิ่มข่าวสารแล้วไป "หน้าเพิ่มข่าวสาร"

### หน้าเพิ่มข่าวสาร (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/171413616-0c5a9383-15c3-41c8-b676-73440407907e.PNG" width="250"> <img src="https://user-images.githubusercontent.com/58208814/171413628-30b09608-52fe-4d4e-b2dd-7b1d60c8461d.PNG" width="250"> 

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อข้อมูล Firebase
- :heavy_check_mark: อัพโหลดรูปภาพ
    - :heavy_check_mark: เมื่อมีรูปให้เปลี่ยน widget เป็นแก้ไขรูป
    - :heavy_check_mark: ห้ามให้ค่าว่าง
    - :heavy_check_mark: ล้างค่ารูปภาพได้
    - :heavy_check_mark: สามารถอัพโหลดลง firestore
- :heavy_check_mark: เพิ่มชื่อหัวเรื่อง โดยห้ามมีค่าว่าง
- :heavy_check_mark: เพิ่มเนื้อหาข่าว โดยสามารถพิมพ์ แล้วขึ้นบรรทัดใหม่ได้ auto
- :heavy_check_mark: สามารถอัพโหลดลง firebase database
- :heavy_check_mark: เพิ่มเสร็จแล้ว ไปหน้าแรก tabbar ที่ 2

### หน้าแก้ไขข่าวสาร (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/171413642-0f029fb8-209d-47ac-8e6d-47347fbd66c0.PNG" width="250"> 

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อข้อมูล Firebase
- :heavy_check_mark: อัพโหลดรูปภาพ
    - :heavy_check_mark: เมื่อมีรูปให้เปลี่ยน widget เป็นแก้ไขรูป
    - :heavy_check_mark: ห้ามให้ค่าว่าง
    - :heavy_check_mark: ล้างค่ารูปภาพ แล้วกลับไปรูปเดิม
    - :heavy_check_mark: สามารถอัพโหลดลง firestore
- :heavy_check_mark: ชื่อหัวเรื่องและเนื้อหา ห้ามมีค่าว่าง
- :heavy_check_mark: เนื้อหาข่าว โดยสามารถพิมพ์ แล้วขึ้นบรรทัดใหม่ได้ auto
- :heavy_check_mark: สามารถอัพโหลดลง firebase database
- :heavy_check_mark: แก้ไขเสร็จแล้ว ไปหน้าแรก tabbar ที่ 2

### หน้าตั้งค่าเพิ่มเติม (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/172160586-1fef642d-e3a0-4108-9e51-96ecb23518c3.PNG" width="250"> 

#### Front-end
- :warning: Design
#### System
- :heavy_check_mark: เมนูสำหรับ Sponsor
    - :heavy_check_mark: กดเมนู "โลโก้สปอนเซอร์" แล้วไปหน้า "จัดการโลโก้"
    - :warning: เมนูส่งใบแสดงผลประกอปการ

### หน้าจัดการโลโก้ (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/172160739-7c94b863-3bfb-41c2-90b2-86babedff7af.PNG" width="250"> <img src="https://user-images.githubusercontent.com/58208814/172160717-69a533ba-da6e-4994-ad58-286d9e3e883f.gif" width="250"> <img src="https://user-images.githubusercontent.com/58208814/172160726-b335c081-1e6a-4406-bbd7-30874432482d.gif" width="250"> 

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อ Firebase
    - :heavy_check_mark: แสดงรายการ logo ในระบบ
- :heavy_check_mark: แก้ไขโลโก้ได้ โดยการเลือกรูปใหม่
    - :heavy_check_mark: ลบข้อมูลภาพจาก Storage และแทนที่
    - :heavy_check_mark: อัพเดตข้อมูลลงใน Firebase
- :heavy_check_mark: สามารถลบโลโก้ออกได้ 
    - :heavy_check_mark: ลบข้อมูลภาพจาก Storage
    - :heavy_check_mark: ลบข้อมูลจาก Firebase

### หน้าข้อมูลขยะ (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/173233802-8610ad42-ae7b-4867-8d74-9a63a08cc9c8.PNG" width="250"> 

#### Front-end
- :heavy_check_mark: Design
#### System
- :heavy_check_mark: เชื่อมต่อ Firebase
    - :heavy_check_mark: แสดงข้อมูล token, exp
    - :heavy_check_mark: แสดงรายละเอียดขยะ
    - :heavy_check_mark: ยกตัวอย่างเผื่อจำไม่ได้
- :heavy_check_mark: เมื่อกดคลิกแล้วให้ส่ง id ไปอ้างอิงในหน้าแก้ไขข้อมูล
- :heavy_check_mark: แสดงข้อมูลแบบ Strame

### หน้าแก้ไขข้อมูลขยะ (ผู้ดูแลระบบ)
<img src="https://user-images.githubusercontent.com/58208814/173233804-3cb37754-9f64-4606-ac14-0fa010578ef8.PNG" width="250"> 

#### Front-end
- :warning: Design
#### System
- :heavy_check_mark: เชื่อมต่อ Firebase
    - :heavy_check_mark: แสดงข้อมูล token, exp
        - :heavy_check_mark: 1.เปลี่ยนข้อมูล token, exp จาก String เป็น int
        - :heavy_check_mark: 2.แยกใส่ List เพื่อนำไปใช้ใน NumberPicker
        - :x: 3.เลื่อนตัวเลขเปลี่ยนค่า แบบทันที
- :x: สามารถบันทึกข้อมูล
- :x: pop-up แก้ไขราคา
    

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="other"></div>

## ระบบเบื้องหลัง

### Database
- :heavy_check_mark: เชื่อมต่อ Firebase App
- :heavy_check_mark: เชื่อมต่อ Firebase Store
- :heavy_check_mark: เชื่อมต่อ Firebase Auther
- :x: เชื่อมต่อ Blockchain

### เพิ่มเติม
- :heavy_check_mark: กำหนด Route กำหนดหน้าจอ
- :heavy_check_mark: กำหนด Constants Font

<p align="right">(<a href="#top">back to top</a>)</p>
