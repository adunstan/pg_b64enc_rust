extern crate libc;
extern crate num;
extern crate rustc_serialize;

use std::ffi::{CString, CStr};
use libc::{uint64_t};
use num::FromPrimitive;
use rustc_serialize::base64::{FromBase64, ToBase64, URL_SAFE};
use std::ascii::AsciiExt;
//use std::ptr;
//use std::str::from_utf8;
//use std::fmt;

#[link(name="b64enc_modmagic", kind="static")]
extern { 
    fn pstrdup(str: *const libc::c_char) -> *const libc::c_char; 
//    fn b64enc_report_error(error_code: i32, 
//                           message: *const libc::c_char,
//                           arg: *const libc::c_char) -> !;
    fn b64enc_send_error(message: *const libc::c_char) ->!;
    fn b64enc_send_notice(message: *const libc::c_char) ;
}

fn report_error(msg: &str) -> ! {
    unsafe {
        let s = CString::new(msg).unwrap();
        b64enc_send_error(s.as_ptr());
    }
}

fn report_notice(msg: &str) {
    unsafe {
        let s = CString::new(msg).unwrap();
        b64enc_send_notice(s.as_ptr());
    }
}

#[no_mangle]
pub fn b64enc_in(str_in: *const libc::c_char) -> uint64_t {
    let encoded = unsafe { CStr::from_ptr(str_in).to_bytes() };
    if !encoded.is_ascii() {
         report_error("not ascii");
    }
    //let s = from_utf8(encoded).unwrap();
    let bytes = encoded.from_base64().unwrap();
    let blen = bytes.len();
    if blen > 8 {
        let bmsg = format!("length of bytes = {}",bytes.len());
        if true {
            report_error(&bmsg);
        }
        report_notice(&bmsg);
    }
    let mut val: u64 = 0;
    for i in 0..blen {
        val = val * 256;
        let incr: u64 =  FromPrimitive::from_u8(bytes[i]).unwrap();
        val = val + incr;
    }
    val
}

#[no_mangle]
pub fn b64enc_out(intval: uint64_t) ->  *const libc::c_char {
    let mut remainder: u64 = intval;
    let mut bytes: [u8; 8] = [0; 8];
    for i in 0..8 {
        bytes[7-i] = FromPrimitive::from_u64(remainder % 256).unwrap();
        remainder = remainder / 256; 
    }
    let encoded = bytes.to_base64(URL_SAFE);
    let s = CString::new(encoded).unwrap();
    unsafe { pstrdup(s.as_ptr()) }
}
