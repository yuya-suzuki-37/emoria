// ギャラリーページ共通JS（reveal / モバイルメニュー / ライトボックス）
const menuBtn=document.getElementById('menuBtn');
const overlayNav=document.getElementById('overlayNav');
if(menuBtn&&overlayNav){
  menuBtn.addEventListener('click',()=>{
    const open=overlayNav.classList.toggle('open');
    document.body.classList.toggle('menu-open',open);
  });
  overlayNav.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{
    overlayNav.classList.remove('open');
    document.body.classList.remove('menu-open');
  }));
}

const io=new IntersectionObserver(entries=>{
  entries.forEach(e=>{if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target)}});
},{threshold:0.12});
document.querySelectorAll('.reveal').forEach(el=>io.observe(el));

const figures=[...document.querySelectorAll('.pg-grid figure')];
const lightbox=document.getElementById('lightbox');
if(lightbox&&figures.length){
  const lbImg=document.getElementById('lbImg');
  const lbCap=document.getElementById('lbCap');
  let currentIdx=0;
  function showLb(){
    const fig=figures[currentIdx];
    lbImg.src=fig.querySelector('img').src;
    lbCap.textContent=fig.dataset.cap||'';
  }
  function openLb(fig){
    currentIdx=figures.indexOf(fig);
    showLb();
    lightbox.classList.add('open');
    document.body.style.overflow='hidden';
  }
  function closeLb(){
    lightbox.classList.remove('open');
    document.body.style.overflow='';
  }
  figures.forEach(f=>f.addEventListener('click',()=>openLb(f)));
  document.getElementById('lbClose').addEventListener('click',closeLb);
  document.getElementById('lbPrev').addEventListener('click',e=>{e.stopPropagation();currentIdx=(currentIdx-1+figures.length)%figures.length;showLb()});
  document.getElementById('lbNext').addEventListener('click',e=>{e.stopPropagation();currentIdx=(currentIdx+1)%figures.length;showLb()});
  lightbox.addEventListener('click',e=>{if(e.target===lightbox)closeLb()});
  document.addEventListener('keydown',e=>{
    if(!lightbox.classList.contains('open'))return;
    if(e.key==='Escape')closeLb();
    if(e.key==='ArrowLeft'){currentIdx=(currentIdx-1+figures.length)%figures.length;showLb()}
    if(e.key==='ArrowRight'){currentIdx=(currentIdx+1)%figures.length;showLb()}
  });
}
