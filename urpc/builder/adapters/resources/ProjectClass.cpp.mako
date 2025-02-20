static const char *RcsId      = "$Id:  $";
static const char *TagName    = "$Name:  $";
static const char *CvsPath    = "$Source:  $";
static const char *SvnPath    = "$HeadURL:  $";
static const char *HttpServer = "http://www.esrf.eu/computing/cs/tango/tango_doc/ds_doc/";
//=============================================================================
//
// file :        ${device_name(protocol)}Class.cpp
//
// description : C++ source for the ${device_name(protocol)}Class.
//               A singleton class derived from DeviceClass.
//               It implements the command and attribute list
//               and all properties and methods required
//               by the ${device_name(protocol)} once per process.
//
// project :     StandaTango
//
// This file is part of Tango device class.
//
// Tango is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Tango is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Tango.  If not, see <http://www.gnu.org/licenses/>.
//
// $Author:  $
//
// $Revision:  $
// $Date:  $
//
// $HeadURL:  $
//
//=============================================================================
//                This file is generated by POGO
//        (Program Obviously used to Generate tango Object)
//=============================================================================


#include "${device_name(protocol)}Class.h"


//-------------------------------------------------------------------
/**
 *	Create ${device_name(protocol)}Class singleton and
 *	return it in a C function for Python usage
 */
//-------------------------------------------------------------------
extern "C" {
#ifdef _TG_WINDOWS_
__declspec(dllexport)
#endif

Tango::DeviceClass *_create_${device_name(protocol)}_class(const char *name) {
    return ${device_name(protocol)}_ns::${device_name(protocol)}Class::init(name);
}
}


namespace ${device_name(protocol)}_ns {


//===================================================================
//	Initialize pointer for singleton pattern
//===================================================================
${device_name(protocol)}Class *${device_name(protocol)}Class::_instance = NULL;

//--------------------------------------------------------
/**
 * method : 		${device_name(protocol)}Class::${device_name(protocol)}Class(string &s)
 * description : 	constructor for the ${device_name(protocol)}Class
 *
 * @param s	The class name
 */
//--------------------------------------------------------
${device_name(protocol)}Class::${device_name(protocol)}Class(string &s):Tango::DeviceClass(s) {
	set_default_property();
	write_class_property();
}

//--------------------------------------------------------
/**
 * method : 		${device_name(protocol)}Class::~${device_name(protocol)}Class()
 * description : 	destructor for the ${device_name(protocol)}Class
 */
//--------------------------------------------------------
${device_name(protocol)}Class::~${device_name(protocol)}Class() {
	_instance = NULL;
}


//--------------------------------------------------------
/**
 * method : 		${device_name(protocol)}Class::init
 * description : 	Create the object if not already done.
 *                  Otherwise, just return a pointer to the object
 *
 * @param	name	The class name
 */
//--------------------------------------------------------
${device_name(protocol)}Class *${device_name(protocol)}Class::init(const char *name) {
	if (_instance == NULL) {
        string s(name);
        _instance = new ${device_name(protocol)}Class(s);
	}
	return _instance;
}

//--------------------------------------------------------
/**
 * method : 		${device_name(protocol)}Class::instance
 * description : 	Check if object already created,
 *                  and return a pointer to the object
 */
//--------------------------------------------------------
${device_name(protocol)}Class *${device_name(protocol)}Class::instance() {
	if (_instance == NULL) {
		std::cerr << "Class is not initialised !!" << std::endl;
		exit(-1);
	}
	return _instance;
}


<%namespace file="${context['import_file']('Project.h.mako')}" import="command_handler_name, attribute_handler_base_name"/>\
<%namespace file="${context['import_file']('ProjectClass.h.mako')}" import="attribute_class_name, command_class_name, type_code"/>\
//===================================================================
//	Properties management
//===================================================================
//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::get_class_property()
 *	Description : Get the class property for specified name.
 */
//--------------------------------------------------------
Tango::DbDatum ${device_name(protocol)}Class::get_class_property(string &prop_name) {
	for (unsigned int i = 0; i < cl_prop.size(); i++) {
		if (cl_prop[i].name == prop_name) {
			return cl_prop[i];
        }
    }
	return Tango::DbDatum(prop_name);
}

//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::get_default_device_property()
 *	Description : Return the default value for device property.
 */
//--------------------------------------------------------
Tango::DbDatum ${device_name(protocol)}Class::get_default_device_property(string &prop_name) {
	for (unsigned int i = 0; i < dev_def_prop.size(); i++) {
		if (dev_def_prop[i].name == prop_name) {
			return dev_def_prop[i];
        }
    }
	return Tango::DbDatum(prop_name);
}

//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::get_default_class_property()
 *	Description : Return the default value for class property.
 */
//--------------------------------------------------------
Tango::DbDatum ${device_name(protocol)}Class::get_default_class_property(string &prop_name) {
	for (unsigned int i = 0; i < cl_def_prop.size(); i++) {
		if (cl_def_prop[i].name == prop_name) {
			return cl_def_prop[i];
        }
    }
	return Tango::DbDatum(prop_name);
}


//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::set_default_property()
 *	Description : Set default property (class and device) for wizard.
 *                For each property, add to wizard property name and description.
 *                If default value has been set, add it to wizard property and
 *                store it in a DbDatum.
 */
//--------------------------------------------------------
void ${device_name(protocol)}Class::set_default_property() {
    string	prop_name;
    string	prop_desc;
    string	prop_def;
    vector<string>	vect_data;

    //	Set Default device Properties
    prop_name = "DevicePath";
    prop_desc = "Filesystem path to file-like device object.";
    prop_def  = "";
    vect_data.clear();
    if (prop_def.length() > 0) {
        Tango::DbDatum	data(prop_name);
        data << vect_data;
        dev_def_prop.push_back(data);
        add_wiz_dev_prop(prop_name, prop_desc,  prop_def);
    } else {
        add_wiz_dev_prop(prop_name, prop_desc);
    }
}

//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::write_class_property()
 *	Description : Set class description fields as property in database
 */
//--------------------------------------------------------
void ${device_name(protocol)}Class::write_class_property()
{
	//	First time, check if database used
	if (Tango::Util::_UseDb == false)
		return;

	Tango::DbData	data;
	string	classname = get_name();
	string	header;
	string::size_type	start, end;

	//	Put title
	Tango::DbDatum	title("ProjectTitle");
	string	str_title("StandaTango");
	title << str_title;
	data.push_back(title);

	//	Put Description
	Tango::DbDatum	description("Description");
	vector<string>	str_desc;
	str_desc.push_back("Tango device server implementation for Standa 8smc4usb motion control device.");
	description << str_desc;
	data.push_back(description);

	//	put cvs or svn location
	string	filename("${device_name(protocol)}");
	filename += "Class.cpp";

	// check for cvs information
	string	src_path(CvsPath);
	start = src_path.find("/");
	if (start!=string::npos)
	{
		end   = src_path.find(filename);
		if (end>start)
		{
			string	strloc = src_path.substr(start, end-start);
			//	Check if specific repository
			start = strloc.find("/cvsroot/");
			if (start!=string::npos && start>0)
			{
				string	repository = strloc.substr(0, start);
				if (repository.find("/segfs/")!=string::npos)
					strloc = "ESRF:" + strloc.substr(start, strloc.length()-start);
			}
			Tango::DbDatum	cvs_loc("cvs_location");
			cvs_loc << strloc;
			data.push_back(cvs_loc);
		}
	}

	// check for svn information
	else
	{
		string	src_path(SvnPath);
		start = src_path.find("://");
		if (start!=string::npos)
		{
			end = src_path.find(filename);
			if (end>start)
			{
				header = "$HeadURL: ";
				start = header.length();
				string	strloc = src_path.substr(start, (end-start));

				Tango::DbDatum	svn_loc("svn_location");
				svn_loc << strloc;
				data.push_back(svn_loc);
			}
		}
	}

	//	Get CVS or SVN revision tag

	// CVS tag
	string	tagname(TagName);
	header = "$Name: ";
	start = header.length();
	string	endstr(" $");

	end   = tagname.find(endstr);
	if (end!=string::npos && end>start)
	{
		string	strtag = tagname.substr(start, end-start);
		Tango::DbDatum	cvs_tag("cvs_tag");
		cvs_tag << strtag;
		data.push_back(cvs_tag);
	}

	// SVN tag
	string	svnpath(SvnPath);
	header = "$HeadURL: ";
	start = header.length();

	end   = svnpath.find(endstr);
	if (end!=string::npos && end>start)
	{
		string	strloc = svnpath.substr(start, end-start);

		string tagstr ("/tags/");
		start = strloc.find(tagstr);
		if ( start!=string::npos )
		{
			start = start + tagstr.length();
			end   = strloc.find(filename);
			string	strtag = strloc.substr(start, end-start-1);

			Tango::DbDatum	svn_tag("svn_tag");
			svn_tag << strtag;
			data.push_back(svn_tag);
		}
	}

	//	Get URL location
	string	httpServ(HttpServer);
	if (httpServ.length()>0)
	{
		Tango::DbDatum	db_doc_url("doc_url");
		db_doc_url << httpServ;
		data.push_back(db_doc_url);
	}

	//  Put inheritance
	Tango::DbDatum	inher_datum("InheritedFrom");
	vector<string> inheritance;
	inheritance.push_back("TANGO_BASE_CLASS");
	inher_datum << inheritance;
	data.push_back(inher_datum);

	//	Call database and and values
	get_db_class()->put_property(data);
}

//===================================================================
//	Factory methods
//===================================================================

//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::device_factory()
 *	Description : Create the device object(s)
 *                and store them in the device list
 */
//--------------------------------------------------------
void ${device_name(protocol)}Class::device_factory(const Tango::DevVarStringArray *devlist_ptr)
{
	// Create devices and add it into the device list
	for (unsigned long i = 0; i < devlist_ptr->length(); ++i) {
		cout4 << "Device name : " << (*devlist_ptr)[i].in() << std::endl;
		device_list.push_back(new ${device_name(protocol)}(this, (*devlist_ptr)[i]));
	}

	// Manage dynamic attributes if any
	erase_dynamic_attributes(devlist_ptr, get_class_attr()->get_attr_list());

	// Export devices to the outside world
	for (unsigned long i = 1 ; i <= devlist_ptr->length(); ++i) {
		// Add dynamic attributes if any
		${device_name(protocol)} *dev = static_cast<${device_name(protocol)} *>(device_list[device_list.size() - i]);

		// Check before if database used.
		if (Tango::Util::_UseDb && !Tango::Util::_FileDb) {
			export_device(dev);
		} else {
			export_device(dev, dev->get_name().c_str());
        }
	}
}

//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::attribute_factory()
 *	Description : Create the attribute object(s)
 *                and store them in the attribute list
 */
//--------------------------------------------------------
void ${device_name(protocol)}Class::attribute_factory(vector<Tango::Attr *> &att_list)
{
	//	Add your own code
<%def name="attribute_instance_create(arg)">
    //	Attribute : ${attribute_handler_base_name(arg)}
    ${attribute_class_name(arg)} *${attribute_handler_base_name(arg)} = new ${attribute_class_name(arg)};
    Tango::UserDefaultAttrProp	${attribute_handler_base_name(arg)}_prop;
    //	description	not set for ${attribute_handler_base_name(arg)}
    //	label	not set for ${attribute_handler_base_name(arg)}
    //	unit	not set for ${attribute_handler_base_name(arg)}
    //	standard_unit	not set for ${attribute_handler_base_name(arg)}
    //	display_unit	not set for ${attribute_handler_base_name(arg)}
    //	format	not set for ${attribute_handler_base_name(arg)}
    //	max_value	not set for ${attribute_handler_base_name(arg)}
    //	min_value	not set for ${attribute_handler_base_name(arg)}
    //	max_alarm	not set for ${attribute_handler_base_name(arg)}
    //	min_alarm	not set for ${attribute_handler_base_name(arg)}
    //	max_warning	not set for ${attribute_handler_base_name(arg)}
    //	min_warning	not set for ${attribute_handler_base_name(arg)}
    //	delta_t	not set for ${attribute_handler_base_name(arg)}
    //	delta_val	not set for ${attribute_handler_base_name(arg)}

% for prop in ( \
        "label", "description", "unit", "standard_unit", "display_unit", \
        "format", "min_value", "max_value", "min_alarm", "max_alarm", "min_warning", \
        "max_warning", "delta_val", "delta_t", "abs_change", "rel_change", "period", \
        "archive_abs_change", "archive_rel_change", "archive_period" \
    ):
    % if attr_get_option_by_name(arg, prop) != "":
    ${attribute_handler_base_name(arg)}_prop.${prop} = "${attr_get_option_by_name(arg, prop)}";
    % endif
% endfor

    ${attribute_handler_base_name(arg)}->set_default_properties(${attribute_handler_base_name(arg)}_prop);
    % if attr_is_reactive(arg):
    ${attribute_handler_base_name(arg)}->set_change_event(true, true);
    % endif
    ${attribute_handler_base_name(arg)}->set_disp_level(Tango::OPERATOR);
    //	Not Memorized
    att_list.push_back(${attribute_handler_base_name(arg)});
</%def>
% for arg in all_args_as_attrs(protocol):
${attribute_instance_create(arg)}
% endfor

	//	Create a list of static attributes
	create_static_attribute_list(get_class_attr()->get_attr_list());
	//	Add your own code
}

//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::command_factory()
 *	Description : Create the command object(s)
 *                and store them in the command list
 */
//--------------------------------------------------------
void ${device_name(protocol)}Class::command_factory()
{
<%def name="command_instance_create(cmd)">\
    // Command ${command_handler_name(cmd)}
    ${command_class_name(cmd)} *p${command_handler_name(cmd)} = new ${command_class_name(cmd)}(
        "${command_handler_name(cmd)}",
        Tango::DEV_VOID,
        Tango::DEV_VOID,
        "",
        "",
        Tango::OPERATOR
    );
    command_list.push_back(p${command_handler_name(cmd)});
</%def>\
% for cmd in all_cmds(protocol):
${command_instance_create(cmd)}
% endfor
}

//===================================================================
//	Dynamic attributes related methods
//===================================================================

//--------------------------------------------------------
/**
 * method : 		${device_name(protocol)}Class::create_static_attribute_list
 * description : 	Create the a list of static attributes
 *
 * @param	att_list	the ceated attribute list
 */
//--------------------------------------------------------
void ${device_name(protocol)}Class::create_static_attribute_list(vector<Tango::Attr *> &att_list)
{
	for (unsigned long i=0 ; i<att_list.size() ; i++)
	{
		string att_name(att_list[i]->get_name());
		transform(att_name.begin(), att_name.end(), att_name.begin(), ::tolower);
		defaultAttList.push_back(att_name);
	}

	cout2 << defaultAttList.size() << " attributes in default list" << endl;
}


//--------------------------------------------------------
/**
 * method : 		${device_name(protocol)}Class::erase_dynamic_attributes
 * description : 	delete the dynamic attributes if any.
 *
 * @param	devlist_ptr	the device list pointer
 * @param	list of all attributes
 */
//--------------------------------------------------------
void ${device_name(protocol)}Class::erase_dynamic_attributes(const Tango::DevVarStringArray *devlist_ptr, vector<Tango::Attr *> &att_list)
{
	Tango::Util *tg = Tango::Util::instance();

	for (unsigned long i=0 ; i<devlist_ptr->length() ; i++)
	{
		Tango::DeviceImpl *dev_impl = tg->get_device_by_name(((string)(*devlist_ptr)[i]).c_str());
		${device_name(protocol)} *dev = static_cast<${device_name(protocol)} *> (dev_impl);

		vector<Tango::Attribute *> &dev_att_list = dev->get_device_attr()->get_attribute_list();
		vector<Tango::Attribute *>::iterator ite_att;
		for (ite_att=dev_att_list.begin() ; ite_att != dev_att_list.end() ; ++ite_att)
		{
			string att_name((*ite_att)->get_name_lower());
			if ((att_name == "state") || (att_name == "status"))
				continue;
			vector<string>::iterator ite_str = find(defaultAttList.begin(), defaultAttList.end(), att_name);
			if (ite_str == defaultAttList.end())
			{
				cout2 << att_name << " is a UNWANTED dynamic attribute for device " << (*devlist_ptr)[i] << endl;
				Tango::Attribute &att = dev->get_device_attr()->get_attr_by_name(att_name.c_str());
				dev->remove_attribute(att_list[att.get_attr_idx()], true, false);
				--ite_att;
			}
		}
	}
}

//--------------------------------------------------------
/**
 *	Method      : ${device_name(protocol)}Class::get_attr_by_name()
 *	Description : returns Tango::Attr * object found by name
 */
//--------------------------------------------------------
Tango::Attr *${device_name(protocol)}Class::get_attr_object_by_name(vector<Tango::Attr *> &att_list, string attname)
{
	for (vector<Tango::Attr *>::iterator it = att_list.begin(); it < att_list.end(); ++it) {
		if ((*it)->get_name()==attname) {
			return (*it);
        }
    }
	return NULL;
}

}	// namespace ${device_name(protocol)}_ns
