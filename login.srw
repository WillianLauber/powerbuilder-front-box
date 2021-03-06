$PBExportHeader$login.srw
forward
global type login from window
end type
type p_entrar from picture within login
end type
type p_1 from picture within login
end type
type st_4 from statictext within login
end type
type cbx_lembrarsenha from checkbox within login
end type
type sle_senha from _textopadrao within login
end type
type sle_nome from _textopadrao within login
end type
type st_3 from statictext within login
end type
type st_2 from statictext within login
end type
type dw_user from datawindow within login
end type
type st_1 from statictext within login
end type
end forward

global type login from window
integer width = 1746
integer height = 2308
boolean titlebar = true
string title = "Login"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 21145709
string icon = "res\img\download.ico"
boolean center = true
p_entrar p_entrar
p_1 p_1
st_4 st_4
cbx_lembrarsenha cbx_lembrarsenha
sle_senha sle_senha
sle_nome sle_nome
st_3 st_3
st_2 st_2
dw_user dw_user
st_1 st_1
end type
global login login

forward prototypes
public subroutine insert_item (datawindow dw_d, string ls_categoria, string ls_nome, string ls_espediente, string ls_senha)
public subroutine changelastuser (string as_name, string as_password)
end prototypes

public subroutine insert_item (datawindow dw_d, string ls_categoria, string ls_nome, string ls_espediente, string ls_senha);int li_linha
li_linha =	dw_d.insertRow(0) // li_linha recebe a ultima linha 
dw_d.setItem(li_linha, "espediente",  ls_espediente)
dw_d.setItem(li_linha, "Name",  ls_nome)
dw_d.setItem(li_linha, "Categoria",  ls_categoria)
dw_d.setItem(li_linha, "Senha", ls_senha)
dw_d.acceptText()
         
    
end subroutine

public subroutine changelastuser (string as_name, string as_password);Update 
	Last_user
SET 
	name = :as_Name, senha =  :as_Password	
Using
	sqlca;
end subroutine

on login.create
this.p_entrar=create p_entrar
this.p_1=create p_1
this.st_4=create st_4
this.cbx_lembrarsenha=create cbx_lembrarsenha
this.sle_senha=create sle_senha
this.sle_nome=create sle_nome
this.st_3=create st_3
this.st_2=create st_2
this.dw_user=create dw_user
this.st_1=create st_1
this.Control[]={this.p_entrar,&
this.p_1,&
this.st_4,&
this.cbx_lembrarsenha,&
this.sle_senha,&
this.sle_nome,&
this.st_3,&
this.st_2,&
this.dw_user,&
this.st_1}
end on

on login.destroy
destroy(this.p_entrar)
destroy(this.p_1)
destroy(this.st_4)
destroy(this.cbx_lembrarsenha)
destroy(this.sle_senha)
destroy(this.sle_nome)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_user)
destroy(this.st_1)
end on

event open;
//conexão com o banco de dados
string ls_error, ls_sql_syntax, ls_as_user, ls_as_password, ls_dbparm, ls_presentation, ls_dwsyntax
String ls_Name, ls_Senha

ls_as_user = 'dba'
ls_as_password = 'a9d9p8.E10'
cbx_lembrarsenha.checked = true

ls_DbParm = "ConnectString='DSN=CISSODBC"
ls_DbParm += ";UID="+ls_as_user+""
ls_DbParm += ";PWD="+ls_as_password+"'"
ls_DbParm += ",ConnectOption='SQL_DRIVER_CONNECT,SQL_DRIVER_NOPROMPT'"
SQLCA.DBMS = "ODBC"
SQLCA.AutoCommit = FALSE
SQLCA.DbParm = ls_DbParm
CONNECT USING SQLCA;

//If(true) then
If(sqlca.sqlcode <> 0) Then
	Messagebox(gs_sistema, "Erro ao conectar ao banco")
else
	dw_user.settransobject(sqlca)
	dw_user.retrieve()

	Select 
		name, senha
	Into
		:ls_Name, :ls_Senha
	From 
		Last_User
	Using
		sqlca;
		
	If(sqlca.sqlcode = 0 ) Then
			sle_nome.sle_padrao.text = ls_Name
			sle_senha.sle_padrao.text = ls_Senha
	End If
End If
end event

event close;Try
	If(main.visible ) Then
		Close(main)
	End if
Catch (runtimeerror EX)
  RETURN -1
End Try
end event

event mousemove;
// just to display something
IF xpos >= p_Entrar.X AND (xpos <= p_Entrar.x + p_Entrar.Width) AND &
     ypos >= p_Entrar.y AND (ypos <= p_Entrar.y + p_Entrar.Height) THEN
	//  messagebox(gs_sistema, "trocar imagem")
	p_entrar.PictureName="C:\Users\willian.lauber\Documents\pB v2\res\img\entrou.jpeg"
 //  p_Entrar.textcolor = 255
ELSE
	
	p_entrar.PictureName="res\img\entrar.jpeg"
	//  messagebox(gs_sistema, "imagem original")
   //p_Entrar.textcolor = 0
END IF
end event

type p_entrar from picture within login
integer x = 402
integer y = 1884
integer width = 914
integer height = 228
string picturename = "res\img\entrar.jpeg"
boolean focusrectangle = false
end type

event clicked;
String ls_Name, ls_Senha, ls_Cargo
Select 
	name, senha, categoria
Into
	:gs_usuario, :ls_Senha, :gs_cargo
From 
	t_user
Where	
	name = :sle_nome.sle_padrao.text and
	senha = :sle_senha.sle_padrao.text
Using
	sqlca;
IF(len(gs_usuario) > 0 and len(ls_Senha) > 0 ) then

	If(cbx_lembrarsenha.checked = true) Then
		ChangeLastUser(sle_nome.sle_padrao.text, sle_senha.sle_padrao.text)
		open(Main)
		Main.show()
		login.hide()
		return
	Else
		open(Main)
		Main.show()
		ChangeLastUser("Nome", "******")
	
		sle_nome.sle_padrao.text = "Nome"
		sle_senha.sle_padrao.text = "*******"
		login.hide()
		return
	end if
return
end if
messagebox(gs_sistema, "Usuario não encontrado")
end event

event getfocus;	p_entrar.PictureName="C:\Users\willian.lauber\Documents\pB v2\res\img\entrou.jpeg"

end event

type p_1 from picture within login
integer x = 608
integer y = 404
integer width = 507
integer height = 420
string picturename = "res\img\login.jpeg"
boolean focusrectangle = false
end type

type st_4 from statictext within login
integer x = 850
integer y = 1548
integer width = 690
integer height = 100
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 134217742
long backcolor = 21145709
string text = "Esqueci minha senha"
boolean focusrectangle = false
end type

event clicked;messagebox(gs_sistema, "Foi enviado um email de recuperação em seu email")
end event

type cbx_lembrarsenha from checkbox within login
integer x = 288
integer y = 1548
integer width = 494
integer height = 104
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217732
long backcolor = 21145709
string text = "Lembrar-me"
end type

type sle_senha from _textopadrao within login
integer x = 274
integer y = 1280
integer width = 1079
integer height = 108
integer taborder = 60
long backcolor = 134217741
string is_textopadrao = "******"
end type

on sle_senha.destroy
call _textopadrao::destroy
end on

type sle_nome from _textopadrao within login
integer x = 293
integer y = 896
integer width = 1065
integer height = 112
integer taborder = 50
string is_textopadrao = "Nome"
end type

on sle_nome.destroy
call _textopadrao::destroy
end on

type st_3 from statictext within login
integer x = 297
integer y = 1188
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217748
long backcolor = 21145709
string text = "Senha"
boolean focusrectangle = false
end type

type st_2 from statictext within login
integer x = 306
integer y = 820
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217748
long backcolor = 21145709
string text = "Usuario"
boolean focusrectangle = false
end type

type dw_user from datawindow within login
boolean visible = false
integer y = 668
integer width = 3031
integer height = 860
integer taborder = 40
boolean enabled = false
string title = "none"
string dataobject = "dw_user"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within login
integer x = 370
integer y = 140
integer width = 1102
integer height = 256
integer textsize = -30
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217742
long backcolor = 21145709
string text = "Login :"
alignment alignment = center!
boolean focusrectangle = false
end type

