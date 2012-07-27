// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package uk.co.vurt.taskhelper.server.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;
import uk.co.vurt.taskhelper.server.domain.definition.AutoTaskDefinition;
import uk.co.vurt.taskhelper.server.domain.definition.ManualTaskDefinition;
import uk.co.vurt.taskhelper.server.domain.job.DataItem;
import uk.co.vurt.taskhelper.server.domain.job.Job;
import uk.co.vurt.taskhelper.server.domain.job.Status;
import uk.co.vurt.taskhelper.server.domain.user.Person;

privileged aspect JobController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public java.lang.String JobController.create(@Valid Job job, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("job", job);
            addDateTimeFormatPatterns(uiModel);
            return "jobs/create";
        }
        uiModel.asMap().clear();
        job.persist();
        return "redirect:/jobs/" + encodeUrlPathSegment(job.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public java.lang.String JobController.createForm(Model uiModel) {
        uiModel.addAttribute("job", new Job());
        addDateTimeFormatPatterns(uiModel);
        List<java.lang.String[]> dependencies = new ArrayList<java.lang.String[]>();
        if (Person.countPeople() == 0) {
            dependencies.add(new String[] { "person", "people" });
        }
        uiModel.addAttribute("dependencies", dependencies);
        return "jobs/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public java.lang.String JobController.show(@PathVariable("id") java.lang.Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("job", Job.findJob(id));
        uiModel.addAttribute("itemId", id);
        return "jobs/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public java.lang.String JobController.list(@RequestParam(value = "page", required = false) java.lang.Integer page, @RequestParam(value = "size", required = false) java.lang.Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("jobs", Job.findJobEntries(firstResult, sizeNo));
            float nrOfPages = (float) Job.countJobs() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("jobs", Job.findAllJobs());
        }
        addDateTimeFormatPatterns(uiModel);
        return "jobs/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public java.lang.String JobController.update(@Valid Job job, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            uiModel.addAttribute("job", job);
            addDateTimeFormatPatterns(uiModel);
            return "jobs/update";
        }
        uiModel.asMap().clear();
        job.merge();
        return "redirect:/jobs/" + encodeUrlPathSegment(job.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public java.lang.String JobController.updateForm(@PathVariable("id") java.lang.Long id, Model uiModel) {
        uiModel.addAttribute("job", Job.findJob(id));
        addDateTimeFormatPatterns(uiModel);
        return "jobs/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public java.lang.String JobController.delete(@PathVariable("id") java.lang.Long id, @RequestParam(value = "page", required = false) java.lang.Integer page, @RequestParam(value = "size", required = false) java.lang.Integer size, Model uiModel) {
        Job job = Job.findJob(id);
        job.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/jobs";
    }
    
    @ModelAttribute("autotaskdefinitions")
    public Collection<AutoTaskDefinition> JobController.populateAutoTaskDefinitions() {
        return AutoTaskDefinition.findAllAutoTaskDefinitions();
    }
    
    @ModelAttribute("manualtaskdefinitions")
    public Collection<ManualTaskDefinition> JobController.populateManualTaskDefinitions() {
        return ManualTaskDefinition.findAllManualTaskDefinitions();
    }
    
    @ModelAttribute("dataitems")
    public Collection<DataItem> JobController.populateDataItems() {
        return DataItem.findAllDataItems();
    }
    
    @ModelAttribute("jobs")
    public Collection<Job> JobController.populateJobs() {
        return Job.findAllJobs();
    }
    
    @ModelAttribute("statuses")
    public Collection<Status> JobController.populateStatuses() {
        return Arrays.asList(Status.class.getEnumConstants());
    }
    
    @ModelAttribute("people")
    public Collection<Person> JobController.populatePeople() {
        return Person.findAllPeople();
    }
    
    void JobController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("job_created_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
        uiModel.addAttribute("job_due_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
    }
    
    java.lang.String JobController.encodeUrlPathSegment(java.lang.String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}