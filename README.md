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
- :x: กดปุ่ม "Back to home" แล้วไปยัง "หน้าแรก" 

### หน้าแรก
<img src="https://user-images.githubusercontent.com/58208814/161980781-9b87cd48-9ac8-44e7-98c9-562437b46c65.png" width="250">

#### Front-end
- :x: Design
#### System
- :x: ไม่สามารถกดเมนูบน ข่าวสารได้ หากกดแล้วจะไปยัง "หน้าโปรดล็อคอิน" 
- :x: ไม่สามารถกดเมนูบน Appbar ได้หากกดแล้วจะไปยัง "หน้าโปรดล็อคอิน"
- :x: สามารถกด Tabbar
- :x: สามารถเข้าดูรายละเอียด ข่าวสารได้
- :warning: Wallet จะต้องไม่แสดงอะไร
- :warning: ดึงข้อมูล Sponsor จาก Firebase มาแสดง 
- :warning: ดึงข้อมูล ข่าวสาร จาก Firebase มาแสดง 

### หน้าอ่านข่าวสาร
<img src="https://user-images.githubusercontent.com/58208814/162737293-205c64a2-859c-4be2-aa16-538a6d26cd37.png" width="250">

#### Front-end
- :x: Design
#### System
- :x: เชื่อมต่อ Firestore
    - :x: ดึงข้อมูลเนื้อหามาแสดง ของแต่ละข่าวสาร
- :warning: กดปุ่ม "Back" แล้วไปยังหน้าที่แล้ว

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



ทำหน้าอ่านข่าว
1. ดึงข้อมูลจาก firebase มาแสดงในหน้า home ให้หมด
2. พอกดคลิกที่ตัว item ก็ให้มัน passing ค่า id ตัวนั้นไปยังหน้า อ่านข่าว
3. ในหน้าอ่านข่าวก็จะดึงค่า id ที่มันส่งมากับตอน Navigator เอามาใช้อ้างอิง id สำหรับอ่านหน้าข่าว 