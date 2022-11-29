unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, openGL, Vcl.StdCtrls, Vcl.ExtCtrls, System.Threading,
  DateUtils;

type
  TParticle = Record
    x,y,z:single;
    r, g, b, a: byte;
    dx,dy,dz:single;
    bright:single;
  End;
  TMainForm = class(TForm)
    Button1: TButton;
    HintLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    DC : HDC;
    hrc: HGLRC;
    mouse_x,mouse_y:single;
  end;

var
  MainForm: TMainForm;
  particles:array[0..100000] of TParticle;                    


implementation

{$R *.dfm}
//Pixel format procedure
procedure SetDCPixelFormat(hdc: HDC);
var
  pfd         : TPixelFormatDescriptor;
  nPixelFormat: Integer;
begin
  FillChar(pfd, SizeOf(pfd), 0);
  pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  nPixelFormat := ChoosePixelFormat(hdc, @pfd);
  SetPixelFormat(hdc, nPixelFormat, @pfd);
end;


procedure DrawProcess;
begin
beep;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  i:Integer;
  angle:single;
  dt:TDateTime;
  fps:word;
begin
Button1.Visible:=false;
dt:=Now;
fps:=0;
while True do begin
  glClear(GL_COLOR_BUFFER_BIT);
  glEnable(GL_BLEND);
  //glBlendFunc(GL_ONE, GL_ONE);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE);
  //glBegin(GL_POINTS);
  //glColor4f; glVertex3f
  //glEnd;
  
  TParallel.&For(0,100000,procedure(i:integer)
  begin
    particles[i].x:=particles[i].x+particles[i].dx/10;
    particles[i].y:=particles[i].y+(particles[i].dy-(1-particles[i].bright)/100)/10;
    particles[i].bright:=particles[i].bright-0.0003;
    particles[i].a:=Round(particles[i].bright*255);
    if (abs(particles[i].x)>1)or(abs(particles[i].y)>1)or(particles[i].bright<0) then begin
      particles[i].x:=MainForm.mouse_x+Random/10-1/20;
      particles[i].y:=-MainForm.mouse_y;
      particles[i].bright:=1;
      if Random<0.3 then begin
        particles[i].r:=0;
        particles[i].g:=255;
        particles[i].b:=255;
      end else begin
        particles[i].r:=Round(0.9*255);
        particles[i].g:=Round(0.8*255);
        particles[i].b:=Round(0.2*255);
      end;
      angle:=Random*2*pi;
      particles[i].dx:=sin(angle)/300;
      particles[i].dy:=cos(angle)/300;
      if GetKeyState(VK_Space)<0 then begin
        particles[i].dx:=particles[i].dx*3;
        particles[i].dy:=particles[i].dy*3;
        end;
      end;
  end);
    //glColor3ub( 255, 255, 255 );
    glEnableClientState( GL_VERTEX_ARRAY );
    glEnableClientState( GL_COLOR_ARRAY );
    glVertexPointer( 2, GL_FLOAT, sizeof(TParticle), @particles[0].x );
    glColorPointer( 4, GL_UNSIGNED_BYTE, sizeof(TParticle), @particles[0].r );
    glPointSize(2);
    glDrawArrays( GL_POINTS, 0, 100000 );
    glDisableClientState( GL_VERTEX_ARRAY );
    glDisableClientState( GL_COLOR_ARRAY );
  SwapBuffers(MainForm.DC);
  application.ProcessMessages;
  if GetKeyState(VK_ESCAPE)<0 then begin
    Close;
    break;
  end;
  inc(fps);
  if MilliSecondsBetween(Now,dt)>1000 then begin
    dt:=Now;
    Caption:='FPS: '+IntToStr(fps)+' Press Esc to Exit';
    fps:=0;
  end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var i:integer;
  angle:single;
begin
  DC := GetDC(Handle);
  SetDCPixelFormat(DC);
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  glShadeModel( GL_SMOOTH );
  //glEnable(GL_POINT_SMOOTH);
  glPointSize(10);
  glColor3f(0, 0.7, 0.9);
  glClearColor(0.1, 0, 0, 1.0);
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  SwapBuffers(DC);
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

for i:=0 to 100000 do begin
  particles[i].x:=0;
  particles[i].y:=0;
  particles[i].z:=0;   
  particles[i].r:=Round(0.9*255);
  particles[i].g:=Round(0.8*255);
  particles[i].b:=Round(0.2*255);
  particles[i].a:=255;
  angle:=Random*2*pi;
  particles[i].dx:=sin(angle)/300;
  particles[i].dy:=cos(angle)/300;
  particles[i].bright:=Random;
end;

end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
mouse_x:=x/width*2-1;
mouse_y:=y/height*2-1;
end;

end.
