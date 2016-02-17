-- Small library for striping accents and other sensitive characters
--
-- kpse.set_program_name("luatex")
local M = {}
local conversion_table =  {
	{base='A', letters=':0041:24B6:FF21:00C0:00C1:00C2:1EA6:1EA4:1EAA:1EA8:00C3:0100:0102:1EB0:1EAE:1EB4:1EB2:0226:01E0:00C4:01DE:1EA2:00C5:01FA:01CD:0200:0202:1EA0:1EAC:1EB6:1E00:0104:023A:2C6F'},
	{base='AA',letters=':A732'},
	{base='AE',letters=':00C6:01FC:01E2'},
	{base='AO',letters=':A734'},
	{base='AU',letters=':A736'},
	{base='AV',letters=':A738:A73A'},
	{base='AY',letters=':A73C'},
	{base='B', letters=':0042:24B7:FF22:1E02:1E04:1E06:0243:0182:0181'},
	{base='C', letters=':0043:24B8:FF23:0106:0108:010A:010C:00C7:1E08:0187:023B:A73E'},
	{base='D', letters=':0044:24B9:FF24:1E0A:010E:1E0C:1E10:1E12:1E0E:0110:018B:018A:0189:A779'},
	{base='DZ',letters=':01F1:01C4'},
	{base='Dz',letters=':01F2:01C5'},
	{base='E', letters=':0045:24BA:FF25:00C8:00C9:00CA:1EC0:1EBE:1EC4:1EC2:1EBC:0112:1E14:1E16:0114:0116:00CB:1EBA:011A:0204:0206:1EB8:1EC6:0228:1E1C:0118:1E18:1E1A:0190:018E'},
	{base='F', letters=':0046:24BB:FF26:1E1E:0191:A77B'},
	{base='G', letters=':0047:24BC:FF27:01F4:011C:1E20:011E:0120:01E6:0122:01E4:0193:A7A0:A77D:A77E'},
	{base='H', letters=':0048:24BD:FF28:0124:1E22:1E26:021E:1E24:1E28:1E2A:0126:2C67:2C75:A78D'},
	{base='I', letters=':0049:24BE:FF29:00CC:00CD:00CE:0128:012A:012C:0130:00CF:1E2E:1EC8:01CF:0208:020A:1ECA:012E:1E2C:0197'},
	{base='J', letters=':004A:24BF:FF2A:0134:0248'},
	{base='K', letters=':004B:24C0:FF2B:1E30:01E8:1E32:0136:1E34:0198:2C69:A740:A742:A744:A7A2'},
	{base='L', letters=':004C:24C1:FF2C:013F:0139:013D:1E36:1E38:013B:1E3C:1E3A:0141:023D:2C62:2C60:A748:A746:A780'},
	{base='LJ',letters=':01C7'},
	{base='Lj',letters=':01C8'},
	{base='M', letters=':004D:24C2:FF2D:1E3E:1E40:1E42:2C6E:019C'},
	{base='N', letters=':004E:24C3:FF2E:01F8:0143:00D1:1E44:0147:1E46:0145:1E4A:1E48:0220:019D:A790:A7A4'},
	{base='NJ',letters=':01CA'},
	{base='Nj',letters=':01CB'},
	{base='O', letters=':004F:24C4:FF2F:00D2:00D3:00D4:1ED2:1ED0:1ED6:1ED4:00D5:1E4C:022C:1E4E:014C:1E50:1E52:014E:022E:0230:00D6:022A:1ECE:0150:01D1:020C:020E:01A0:1EDC:1EDA:1EE0:1EDE:1EE2:1ECC:1ED8:01EA:01EC:00D8:01FE:0186:019F:A74A:A74C'},
	{base='OI',letters=':01A2'},
	{base='OO',letters=':A74E'},
	{base='OU',letters=':0222'},
	{base='P', letters=':0050:24C5:FF30:1E54:1E56:01A4:2C63:A750:A752:A754'},
	{base='Q', letters=':0051:24C6:FF31:A756:A758:024A'},
	{base='R', letters=':0052:24C7:FF32:0154:1E58:0158:0210:0212:1E5A:1E5C:0156:1E5E:024C:2C64:A75A:A7A6:A782'},
	{base='S', letters=':0053:24C8:FF33:1E9E:015A:1E64:015C:1E60:0160:1E66:1E62:1E68:0218:015E:2C7E:A7A8:A784'},
	{base='T', letters=':0054:24C9:FF34:1E6A:0164:1E6C:021A:0162:1E70:1E6E:0166:01AC:01AE:023E:A786'},
	{base='TZ',letters=':A728'},
	{base='U', letters=':0055:24CA:FF35:00D9:00DA:00DB:0168:1E78:016A:1E7A:016C:00DC:01DB:01D7:01D5:01D9:1EE6:016E:0170:01D3:0214:0216:01AF:1EEA:1EE8:1EEE:1EEC:1EF0:1EE4:1E72:0172:1E76:1E74:0244'},
	{base='V', letters=':0056:24CB:FF36:1E7C:1E7E:01B2:A75E:0245'},
	{base='VY',letters=':A760'},
	{base='W', letters=':0057:24CC:FF37:1E80:1E82:0174:1E86:1E84:1E88:2C72'},
	{base='X', letters=':0058:24CD:FF38:1E8A:1E8C'},
	{base='Y', letters=':0059:24CE:FF39:1EF2:00DD:0176:1EF8:0232:1E8E:0178:1EF6:1EF4:01B3:024E:1EFE'},
	{base='Z', letters=':005A:24CF:FF3A:0179:1E90:017B:017D:1E92:1E94:01B5:0224:2C7F:2C6B:A762'},
	{base='a', letters=':0061:24D0:FF41:1E9A:00E0:00E1:00E2:1EA7:1EA5:1EAB:1EA9:00E3:0101:0103:1EB1:1EAF:1EB5:1EB3:0227:01E1:00E4:01DF:1EA3:00E5:01FB:01CE:0201:0203:1EA1:1EAD:1EB7:1E01:0105:2C65:0250'},
	{base='aa',letters=':A733'},
	{base='ae',letters=':00E6:01FD:01E3'},
	{base='ao',letters=':A735'},
	{base='au',letters=':A737'},
	{base='av',letters=':A739:A73B'},
	{base='ay',letters=':A73D'},
	{base='b', letters=':0062:24D1:FF42:1E03:1E05:1E07:0180:0183:0253'},
	{base='c', letters=':0063:24D2:FF43:0107:0109:010B:010D:00E7:1E09:0188:023C:A73F:2184'},
	{base='d', letters=':0064:24D3:FF44:1E0B:010F:1E0D:1E11:1E13:1E0F:0111:018C:0256:0257:A77A'},
	{base='dz',letters=':01F3:01C6'},
	{base='e', letters=':0065:24D4:FF45:00E8:00E9:00EA:1EC1:1EBF:1EC5:1EC3:1EBD:0113:1E15:1E17:0115:0117:00EB:1EBB:011B:0205:0207:1EB9:1EC7:0229:1E1D:0119:1E19:1E1B:0247:025B:01DD'},
	{base='f', letters=':0066:24D5:FF46:1E1F:0192:A77C'},
	{base='g', letters=':0067:24D6:FF47:01F5:011D:1E21:011F:0121:01E7:0123:01E5:0260:A7A1:1D79:A77F'},
	{base='h', letters=':0068:24D7:FF48:0125:1E23:1E27:021F:1E25:1E29:1E2B:1E96:0127:2C68:2C76:0265'},
	{base='hv',letters=':0195'},
	{base='i', letters=':0069:24D8:FF49:00EC:00ED:00EE:0129:012B:012D:00EF:1E2F:1EC9:01D0:0209:020B:1ECB:012F:1E2D:0268:0131'},
	{base='j', letters=':006A:24D9:FF4A:0135:01F0:0249'},
	{base='k', letters=':006B:24DA:FF4B:1E31:01E9:1E33:0137:1E35:0199:2C6A:A741:A743:A745:A7A3'},
	{base='l', letters=':006C:24DB:FF4C:0140:013A:013E:1E37:1E39:013C:1E3D:1E3B:017F:0142:019A:026B:2C61:A749:A781:A747'},
	{base='lj',letters=':01C9'},
	{base='m', letters=':006D:24DC:FF4D:1E3F:1E41:1E43:0271:026F'},
	{base='n', letters=':006E:24DD:FF4E:01F9:0144:00F1:1E45:0148:1E47:0146:1E4B:1E49:019E:0272:0149:A791:A7A5'},
	{base='nj',letters=':01CC'},
	{base='o', letters=':006F:24DE:FF4F:00F2:00F3:00F4:1ED3:1ED1:1ED7:1ED5:00F5:1E4D:022D:1E4F:014D:1E51:1E53:014F:022F:0231:00F6:022B:1ECF:0151:01D2:020D:020F:01A1:1EDD:1EDB:1EE1:1EDF:1EE3:1ECD:1ED9:01EB:01ED:00F8:01FF:0254:A74B:A74D:0275'},
	{base='oi',letters=':01A3'},
	{base='ou',letters=':0223'},
	{base='oo',letters=':A74F'},
	{base='p',letters=':0070:24DF:FF50:1E55:1E57:01A5:1D7D:A751:A753:A755'},
	{base='q',letters=':0071:24E0:FF51:024B:A757:A759'},
	{base='r',letters=':0072:24E1:FF52:0155:1E59:0159:0211:0213:1E5B:1E5D:0157:1E5F:024D:027D:A75B:A7A7:A783'},
	{base='s',letters=':0073:24E2:FF53:00DF:015B:1E65:015D:1E61:0161:1E67:1E63:1E69:0219:015F:023F:A7A9:A785:1E9B'},
	{base='t',letters=':0074:24E3:FF54:1E6B:1E97:0165:1E6D:021B:0163:1E71:1E6F:0167:01AD:0288:2C66:A787'},
	{base='tz',letters=':A729'},
	{base='u',letters= ':0075:24E4:FF55:00F9:00FA:00FB:0169:1E79:016B:1E7B:016D:00FC:01DC:01D8:01D6:01DA:1EE7:016F:0171:01D4:0215:0217:01B0:1EEB:1EE9:1EEF:1EED:1EF1:1EE5:1E73:0173:1E77:1E75:0289'},
	{base='v',letters=':0076:24E5:FF56:1E7D:1E7F:028B:A75F:028C'},
	{base='vy',letters=':A761'},
	{base='w',letters=':0077:24E6:FF57:1E81:1E83:0175:1E87:1E85:1E98:1E89:2C73'},
	{base='x',letters=':0078:24E7:FF58:1E8B:1E8D'},
	{base='y',letters=':0079:24E8:FF59:1EF3:00FD:0177:1EF9:0233:1E8F:00FF:1EF7:1E99:1EF5:01B4:024F:1EFF'},
	{base='z',letters=':007A:24E9:FF5A:017A:1E91:017C:017E:1E93:1E95:01B6:0225:0240:2C6C:A763'}
}

local function prepare_table(conv, func)
	local codes = {}
	local func = func or function(c) return c end -- 
	local make_codes = function(base,letters)
		local base = func(base)
		local chcode = unicode.utf8.char
		letters:gsub('([0-9A-F]+)', function(char)
      local letter =chcode(tonumber(char,16))
			codes[letter] = base
		end)
	end
	for _,c in ipairs(conv) do
		make_codes(c.base, c.letters)
	end
	return codes
end

-- Replace characters which can cause problems in url
local special_chars = function(codes)
	local codes = codes or {}
	codes[" "] = "_"
	local removes =	"<>.?!&$%^*@#{}()[]"
  removes:gsub("(.)", function(c) codes[c] = "" end)
	return codes
end

-- default conversion table is created, all letters are converted to lower case
-- this table is used when strip_accents("string") is called
local tolower = unicode.utf8.lower
local codes = special_chars(prepare_table(conversion_table, tolower))

local gsub = unicode.utf8.gsub

local strip_accents = function(k,tb)
	local tb =  tb or codes
	return gsub(k,"(.)",function(c)
		local p = tb[c] or c
		return p
	end)
end

-- Testing code
-- local k = arg[1] or "Příliš žluťoučký kůň úpěl ďábelské ódy"
-- local t = strip_accents(k)
-- print(t)
M.prepare_table =  prepare_table
M.special_chars = special_chars
M.strip_accents = strip_accents
return M
