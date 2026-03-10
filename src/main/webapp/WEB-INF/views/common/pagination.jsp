<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 通用分页片段：依赖于外部设置的 baseUrl、query、pageNum、pageSize、total --%>
<c:choose>
    <c:when test="${pageSize == null || pageSize <= 0}">
        <c:set var="totalPages" value="0"/>
    </c:when>
    <c:otherwise>
        <c:set var="totalPages" value="${(total/pageSize)+(total%pageSize==0?0:1)}"/>
    </c:otherwise>
</c:choose>
<c:if test="${totalPages > 1}">
    <nav>
        <ul class="pagination justify-content-center">
            <!-- 上一页 -->
            <li class="page-item ${pageNum==1? 'disabled' : ''}">
                <a class="page-link"
                   href="${baseUrl}?${query}&amp;pageNum=${pageNum-1}&amp;pageSize=${pageSize}">上一页</a>
            </li>

            <!-- 数字页码 -->
            <c:forEach var="i" begin="1" end="${totalPages}">
                <li class="page-item ${i==pageNum? 'active' : ''}">
                    <a class="page-link"
                       href="${baseUrl}?${query}&amp;pageNum=${i}&amp;pageSize=${pageSize}">${i}</a>
                </li>
            </c:forEach>

            <!-- 下一页 -->
            <li class="page-item ${pageNum==totalPages? 'disabled' : ''}">
                <a class="page-link"
                   href="${baseUrl}?${query}&amp;pageNum=${pageNum+1}&amp;pageSize=${pageSize}">下一页</a>
            </li>
        </ul>
    </nav>
</c:if> 