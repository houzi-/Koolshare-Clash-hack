import{E as v,ah as C,ai as _,V as k,aj as y,ak as R,b as c,j as a,U as B,B as T,u as g,d as F,g as S,C as $,h as A}from"./index.31d0d1dc.js";import{a as j,V as q}from"./index.esm.8c5915bf.js";import{R as P,T as z}from"./TextFitler.e1325e60.js";import{f as E}from"./index.c54634b9.js";import{F as L,p as Q}from"./Fab.4a89b536.js";import{u as D}from"./useRemainingViewPortHeight.76d7ff5c.js";import"./debounce.c2d20996.js";function U(e){const r=e.providers,t=Object.keys(r),s={};for(let n=0;n<t.length;n++){const i=t[n];s[i]={...r[i],idx:n}}return{byName:s,names:t}}async function V(e,r){const{url:t,init:s}=v(r);let n={providers:{}};try{const i=await fetch(t+e,s);i.ok&&(n=await i.json())}catch(i){console.log("failed to GET /providers/rules",i)}return U(n)}async function I({name:e,apiConfig:r}){const{url:t,init:s}=v(r);try{return(await fetch(t+`/providers/rules/${e}`,{method:"PUT",...s})).ok}catch(n){return console.log("failed to PUT /providers/rules/:name",n),!1}}async function W({names:e,apiConfig:r}){for(let t=0;t<e.length;t++)await I({name:e[t],apiConfig:r})}var H=function(e,r,t,s,n,i,o,d){if(!e){var l;if(r===void 0)l=new Error("Minified exception occurred; use the non-minified dev environment for the full error message and additional helpful warnings.");else{var m=[t,s,n,i,o,d],x=0;l=new Error(r.replace(/%s/g,function(){return m[x++]})),l.name="Invariant Violation"}throw l.framesToPop=1,l}},M=H;function O(e){return M(e.rules&&e.rules.length>=0,"there is no valid rules list in the rules API response"),e.rules.map((r,t)=>({...r,id:t}))}async function G(e,r){let t={rules:[]};try{const{url:s,init:n}=v(r),i=await fetch(s+e,n);i.ok&&(t=await i.json())}catch(s){console.log("failed to fetch rules",s)}return O(t)}const w=C({key:"ruleFilterText",default:""});function J(e,r){const t=y(),{mutate:s,isLoading:n}=R(I,{onSuccess:()=>{t.invalidateQueries("/providers/rules")}});return[o=>{o.preventDefault(),s({name:e,apiConfig:r})},n]}function K(e){const r=y(),{data:t}=N(e),{mutate:s,isLoading:n}=R(W,{onSuccess:()=>{r.invalidateQueries("/providers/rules")}});return[o=>{o.preventDefault(),s({names:t.names,apiConfig:e})},n]}function N(e){return _(["/providers/rules",e],()=>V("/providers/rules",e))}function X(e){const{data:r,isFetching:t}=_(["/rules",e],()=>G("/rules",e)),{data:s}=N(e),[n]=k(w);if(n==="")return{rules:r,provider:s,isFetching:t};{const i=n.toLowerCase();return{rules:r.filter(o=>o.payload.toLowerCase().indexOf(i)>=0),isFetching:t,provider:{byName:s.byName,names:s.names.filter(o=>o.toLowerCase().indexOf(i)>=0)}}}}const Y="_RuleProviderItem_12aid_1",Z="_left_12aid_7",ee="_middle_12aid_14",te="_gray_12aid_21",re="_action_12aid_25",ne="_refreshBtn_12aid_32",u={RuleProviderItem:Y,left:Z,middle:ee,gray:te,action:re,refreshBtn:ne};function se({idx:e,name:r,vehicleType:t,behavior:s,updatedAt:n,ruleCount:i,apiConfig:o}){const[d,l]=J(r,o),m=E(new Date(n),new Date);return c("div",{className:u.RuleProviderItem,children:[a("span",{className:u.left,children:e}),c("div",{className:u.middle,children:[a(B,{name:r,type:`${t} / ${s}`}),a("div",{className:u.gray,children:i<2?`${i} rule`:`${i} rules`}),c("div",{className:u.action,children:[c(T,{onClick:d,disabled:l,className:u.refreshBtn,children:[a(P,{isRotating:l,size:13}),a("span",{className:"visually-hidden",children:"Refresh"})]}),c("small",{className:u.gray,children:["Updated ",m," ago"]})]})]})]})}function ie({apiConfig:e}){const[r,t]=K(e),{t:s}=g();return a(L,{icon:a(P,{isRotating:t}),text:s("update_all_rule_provider"),style:Q,onClick:r})}const ae="_rule_1ymqx_1",oe="_left_1ymqx_12",le="_a_1ymqx_19",ce="_b_1ymqx_26",ue="_type_1ymqx_37",f={rule:ae,left:oe,a:le,b:ce,type:ue},h={_default:"#59caf9",DIRECT:"#f5bc41",REJECT:"#cb3166"};function de({proxy:e}){let r=h._default;return h[e]&&(r=h[e]),{color:r}}function me({type:e,payload:r,proxy:t,id:s}){const n=de({proxy:t});return c("div",{className:f.rule,children:[a("div",{className:f.left,children:s}),c("div",{children:[a("div",{className:f.b,children:r}),c("div",{className:f.a,children:[a("div",{className:f.type,children:e}),a("div",{style:n,children:t})]})]})]})}const fe="_header_1j1w3_1",he="_RuleProviderItemWrapper_1j1w3_17",b={header:fe,RuleProviderItemWrapper:he},{memo:ve}=A,p=30;function pe(e,{rules:r,provider:t}){const s=t.names.length;return e<s?t.names[e]:r[e-s].id}function _e({provider:e}){return function(t){const s=e.names.length;return t<s?110:80}}const ye=ve(({index:e,style:r,data:t})=>{const{rules:s,provider:n,apiConfig:i}=t,o=n.names.length;if(e<o){const l=n.names[e],m=n.byName[l];return a("div",{style:r,className:b.RuleProviderItemWrapper,children:a(se,{apiConfig:i,...m})})}const d=s[e-o];return a("div",{style:r,children:a(me,{...d})})},j),Re=e=>({apiConfig:S(e)}),ke=F(Re)(ge);function ge({apiConfig:e}){const[r,t]=D(),{rules:s,provider:n}=X(e),i=_e({provider:n}),{t:o}=g();return c("div",{children:[c("div",{className:b.header,children:[a($,{title:o("Rules")}),a(z,{placeholder:"Filter",textAtom:w})]}),a("div",{ref:r,style:{paddingBottom:p},children:a(q,{height:t-p,width:"100%",itemCount:s.length+n.names.length,itemSize:i,itemData:{rules:s,provider:n,apiConfig:e},itemKey:pe,children:ye})}),n&&n.names&&n.names.length>0?a(ie,{apiConfig:e}):null]})}export{ke as default};
